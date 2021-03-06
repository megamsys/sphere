class OrganisationClient < ActiveRecord::Base
  include PgSearch
  include Sspable
  include Taggable
  include Vcardable
  include I18n::Alchemy

  # Associations
  belongs_to :organisation
  has_many :reservations, dependent: :destroy
  has_many :stickies, as: :stickable, dependent: :destroy
  has_many :contacts, class_name: 'OrganisationClientContact', dependent: :destroy, inverse_of: :organisation_client
  has_many :documents, as: :documentable, dependent: :destroy, inverse_of: :documentable
  has_many :communication_records, dependent: :destroy, inverse_of: :organisation_client

  # Model extensions
  audited only: [:first_name, :last_name, :infix, :email, :route, :street_number, :postal_code, :locality, :country, :administrative_area_level_2, :administrative_area_level_1, :phone, :mobile_phone, :business_client, :company_name, :tax_number, :iban, :iban_att], allow_mass_assignment: true

  # Validations
  validates :organisation, presence: true
  validates :first_name, presence: true, unless: -> { business_client }
  validates :last_name, presence: true, unless: -> { business_client }
  validates :company_name, presence: true, if: -> { business_client }
  validates :email, length: { maximum: 255 }, email: true, allow_blank: true
  validates :route, length: { maximum: 255 }
  validates :street_number, length: { maximum: 255 }
  validates :locality, length: { maximum: 255 }
  validates :administrative_area_level_2, length: { maximum: 255 }
  validates :administrative_area_level_1, length: { maximum: 255 }
  validates :country, length: { maximum: 255 }
  validates :postal_code, length: { maximum: 255 }
  validates :iban_att, presence: true, if: -> { iban.present? }
  validate :iban_valid, if: -> { iban.present? }

  # Nested attributes
  accepts_nested_attributes_for :contacts, allow_destroy: true

  # Scopes
  pg_global_search against: { first_name: 'A', infix: 'C', last_name: 'A', email: 'A', route: 'B', street_number: 'B', locality: 'B', postal_code: 'B', country: 'B', phone: 'C', mobile_phone: 'C' }, associated_against: { stickies: { sticky_text: 'C' } }

  default_scope { order(:last_name, :first_name, :locality) }

  # Class methods

  # Search OrganisationClients for autocomplete. Finds all clients for which one of the columns matches the query. Multiple query words limit the results.
  def self.autocomplete_search(query)
    # PERFORMANCE: use indexes to improve performance
    query.split(' ').inject(self) do |relation, subquery|
      subquery = subquery.gsub(/[^a-zA-Z0-9]/, '') + '%' # Remove all punctuation marks from the query and add % wildcard
      relation.where('first_name ILIKE :subquery OR last_name ILIKE :subquery OR locality ILIKE :subquery', subquery: subquery)
    end.reorder(updated_at: :desc)
  end

  def self.sort_on_class_attribute(cls, sort, direction)
    if cls == self && sort == 'name'
      check_sort_direction(direction)
      # TODO: also sort on first_name and locality
      reorder("CASE WHEN #{table_name}.business_client THEN #{table_name}.company_name ELSE #{table_name}.last_name END #{direction.upcase}").merge(@default_order)
    else
      super
    end
  end

  # Instance methods

  # When changing this, also change the custom sorting for name (sortable table header), see sort_on_class_attribute
  def instance_name
    name = (business_client ? company_name : full_name)
    (locality.present? ? "#{name}, #{locality}" : name)
  end

  def full_name
    "#{last_name}, #{first_name}#{infix.present? ? (' ' + infix) : ''}"
  end

  def municipality
    "#{administrative_area_level_2}#{administrative_area_level_1.present? ? (', ' + administrative_area_level_1) : ''}"
  end

  def upcoming_reservations(limit)
    rel = reservations.now_or_future.reorder(:begins_at)
    rel = rel.limit(limit) if limit.present?
    rel
  end

  def past_reservations(limit)
    rel = reservations.past.reorder(ends_at: :desc)
    rel = rel.limit(limit) if limit.present?
    rel
  end

  def iban_valid
    iban_model = IBANTools::IBAN.new(iban)
    iban_errors = iban_model.validation_errors
    if iban_errors.present?
      iban_errors.each do |e|
        errors.add(:iban, e)
      end
    else
      self.iban = iban_model.prettify
    end
  end

  def vcard
    Vcard::Vcard::Maker.make2 do |maker|
      # Setting up name
      if business_client
        # Vcard standard requires a name, so use the company name as the last name
        maker.add_name do |name|
          name.family = company_name
        end
        maker.org = company_name
      else
        maker.add_name do |name|
          name.given = first_name
          name.family = "#{infix.present? ? infix + ' ' : ''}#{last_name}"
        end
      end

      # Setting up address
      maker.add_addr do |addr|
        addr.street = route + ' ' +  street_number
        addr.postalcode = postal_code
        addr.locality = locality
        addr.region = municipality
        addr.country = country
      end

      maker.add_tel(phone) { |e| e.location = 'work' } if phone.present?
      maker.add_tel(mobile_phone) { |e| e.location = 'cell' } if mobile_phone.present?
      maker.add_email(email) { |e| e.location = 'work' }  if email.present?
    end
  end
end

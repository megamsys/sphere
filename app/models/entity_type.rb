class EntityType < ActiveRecord::Base
  has_many :entities, dependent: :destroy
  has_many :properties, class_name: 'EntityTypeProperty', dependent: :destroy, inverse_of: :entity_type

  belongs_to :icon, class_name: 'EntityTypeIcon'

  validates :name, presence: true, length: { maximum: 255 }

  accepts_nested_attributes_for :properties, allow_destroy: true

  def icon_with_default
    if self.icon_without_default.nil?
      EntityTypeIcon.first
    else
      self.icon_without_default
    end
  end
  alias_method_chain :icon, :default

  def instance_name
    self.name
  end
end

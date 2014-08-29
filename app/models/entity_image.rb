class EntityImage < ActiveRecord::Base
  # Associations
  belongs_to :entity_imageable, polymorphic: true
  belongs_to :organisation

  # Attribute modifiers
  mount_uploader :image, EntityImageUploader

  # Validations
  validates :title, length: { maximum: 255 }
  validates :entity_imageable, presence: true
  validates :entity_imageable_type, presence: true, length: { maximum: 255 }
  validates :organisation, presence: true
  validates :image, presence: true

  # Callbacks
  before_validation :set_organisation

  def instance_name
    self.title
  end

private
  def set_organisation
    self.organisation = self.entity_imageable.organisation
  end
end

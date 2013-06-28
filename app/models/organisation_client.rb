class OrganisationClient < ActiveRecord::Base
  belongs_to :organisation
  has_many :reservations, dependent: :destroy

  validates :first_name, presence: true
  validates :infix, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, length: { maximum: 255 }

  def instance_name
    self.first_name
  end
end
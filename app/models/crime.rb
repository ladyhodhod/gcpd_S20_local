class Crime < ApplicationRecord
  
  include AppHelpers::Deletions

  # Relationships
  has_many :crime_investigations
  has_many :investigations, through: :crime_investigations
  
  # Scopes
  scope :alphabetical, -> { order(:name) }
  scope :felonies, -> { where(felony: true) }
  scope :misdemeanors, -> { where.not(felony: true) }
  scope :active, -> { where(active: true)}
  scope :inactive, -> { where.not(active: true)}

  # Validations
  validates :name, presence: true, uniqueness: { case_sensitive: false }

  # Callback - to prevent deletions
  before_destroy -> { cannot_destroy_object() }

  def make_active
    self.active = true
    self.save!
  end
  
  def make_inactive
    self.active = false
    self.save!
  end
end

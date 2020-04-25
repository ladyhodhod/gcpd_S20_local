class Officer < ApplicationRecord
  # Modules to extend functionality
  include AppHelpers::Activeable::InstanceMethods
  extend AppHelpers::Activeable::ClassMethods
  include AppHelpers::Validations

  # Relationships
  belongs_to :unit
  has_many :assignments
  has_many :investigations, through: :assignments
  has_many :investigation_notes
  attr_accessor :destroyable

  # Scopes
  scope :alphabetical, -> { order('last_name, first_name') }
  scope :for_unit, -> (unit_id){ where(unit_id: unit_id) }
  scope :detectives, -> { where('rank LIKE ?', "%detective%") }
  scope :search, ->(term) { where('first_name LIKE ? OR last_name LIKE ?', "#{term}%", "#{term}%") }
  
  # Validations
  validates_presence_of :first_name, :last_name, :unit_id, :role
  validates_format_of :ssn, with: /\A\d{3}[- ]?\d{2}[- ]?\d{4}\z/, message: "should be 9 digits and delimited with dashes only"
  validates_uniqueness_of :ssn
  validate -> { is_active_in_system(:unit) }
  validates_inclusion_of :rank, in: %w[Officer Sergeant Detective Detective\ Sergeant Lieutenant Captain Commissioner], message: "is not an option", allow_blank: true
  validates_inclusion_of :role, in: %w[officer chief commish], message: "is not an option"

  # Other methods
  RANKS_LIST = [['Officer', 'Officer'],['Sergeant', 'Sergeant'],['Detective', 'Detective'],['Detective Sergeant', 'Detective Sergeant'],['Lieutenant', 'Lieutenant'],['Captain', 'Captain'],['Commissioner', 'Commissioner']].freeze

  def name
    "#{last_name}, #{first_name}"
  end
  
  def proper_name
    "#{first_name} #{last_name}"
  end
  
  def current_assignments
    current = self.assignments.select{|a| a.end_date.nil?}
    return nil if current.empty?
    current
  end

  # Callbacks
  before_save    -> { strip_nondigits_from(:ssn) }

  include OfficerDeletion
  before_destroy -> { handle_deletion_request() }
  after_rollback -> { handle_deletion_failure() }
  before_save    -> { remove_assignments_from_inactive_officer() }
end

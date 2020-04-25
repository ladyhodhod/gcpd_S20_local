# require needed files
require './test/sets/units'
require './test/sets/crimes'
require './test/sets/officers'
require './test/sets/investigations'
require './test/sets/crime_investigations'
require './test/sets/assignments'
require './test/sets/investigation_notes'
require './test/sets/abilities'


module Contexts
  # explicitly include all sets of contexts used for testing 
  include Contexts::Units
  include Contexts::Crimes
  include Contexts::Officers
  include Contexts::Investigations
  include Contexts::CrimeInvestigations
  include Contexts::Assignments
  include Contexts::InvestigationNotes
  include Contexts::Abilities
  
  def create_all
    puts "Building context..."
    create_units
    puts "Built units"
    create_crimes
    puts "Built crimes"
    create_officers
    puts "Built officers"
    create_investigations
    puts "Built investigations"
    create_assignments
    puts "Built assignments"
    create_investigation_notes
    puts "Built investigation notes"

  end
  
end
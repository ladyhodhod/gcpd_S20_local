require 'test_helper'

class CrimeInvestigationTest < ActiveSupport::TestCase
  # Relationship matchers
  should belong_to(:investigation)
  should belong_to(:crime)

  # Validation matchers
  should validate_presence_of(:investigation_id)
  should validate_presence_of(:crime_id)

  # Context
  context "Within context" do
    setup do
      create_crimes
      create_investigations
      create_crime_investigations
    end

    should "have a scope for_crime passing in a crime object" do
      assert_equal [@lacey], CrimeInvestigation.for_crime(@murder).map{|ci| ci.investigation }
    end

    should "have a scope for_investigation passing in an investigation object" do
      assert_equal [@murder], CrimeInvestigation.for_investigation(@lacey).map{|ci| ci.crime }
      assert_equal 2, CrimeInvestigation.for_investigation(@pussyfoot).count
    end

    should "identify a non-active crime as invalid" do
      bad_crime = FactoryBot.build(:crime_investigation, investigation: @lacey, crime: @murder2)
      deny bad_crime.valid?
    end

    should "identify a closed case as invalid" do
      closed_investigation = FactoryBot.build(:crime_investigation, investigation: @pussyfoot, crime: @murder)
      deny closed_investigation.valid?
    end
  end
end

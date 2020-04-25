require 'test_helper'

class OfficerTest < ActiveSupport::TestCase
  # Relationship matchers
  should belong_to(:unit)
  should have_many(:assignments)
  should have_many(:investigations).through(:assignments)
  should have_many(:investigation_notes)

  # Validation matchers
  should validate_presence_of(:first_name)
  should validate_presence_of(:last_name)
  should validate_presence_of(:unit_id)
  should validate_uniqueness_of(:ssn)

  should allow_value("123456789").for(:ssn)
  should allow_value("123-45-6789").for(:ssn)
  should allow_value("123 45 6789").for(:ssn)
  should_not allow_value("12345678").for(:ssn)
  should_not allow_value("1234567890").for(:ssn)
  should_not allow_value("bad").for(:ssn)
  should_not allow_value(nil).for(:ssn)

  # short way...
  should validate_inclusion_of(:rank).in_array(%w[Officer Sergeant Detective Detective\ Sergeant Lieutenant Captain Commissioner])
  # long way...
  should allow_value("Officer").for(:rank)
  should allow_value("Sergeant").for(:rank)
  should allow_value("Detective").for(:rank)
  should allow_value("Detective Sergeant").for(:rank)
  should allow_value("Lieutenant").for(:rank)
  should allow_value("Captain").for(:rank)
  should allow_value("Commissioner").for(:rank)
  should allow_value(nil).for(:rank)
  should_not allow_value("bad").for(:rank)
  should_not allow_value("officer").for(:rank)
  should_not allow_value("Major").for(:rank)
  should_not allow_value("1").for(:rank)

  # Context
  context "Within context" do
    setup do
      create_units
      create_officers
    end

    should "have active and inactive scopes" do
      assert_equal 4, Officer.active.count
      assert_equal [@jazeveda, @jblake, @jgordon, @msawyer], Officer.active.to_a.sort_by{|o| o.last_name}
      assert_equal 1, Officer.inactive.count
      assert_equal [@gloeb], Officer.inactive.to_a
    end

    should "have make_active and make_inactive methods" do
      assert @jblake.active
      @jblake.make_inactive
      @jblake.reload
      deny @jblake.active
      @jblake.make_active
      @jblake.reload
      assert @jblake.active
    end

    should "have an alphabetical scope for ordering" do
      assert_equal [@jazeveda, @jblake, @jgordon, @gloeb, @msawyer], Officer.alphabetical.to_a
    end

    should "have a detectives scope" do
      assert_equal 2, Officer.detectives.count
      assert_equal [@jazeveda, @jblake], Officer.detectives.to_a.sort_by{|o| o.last_name}
    end

    should "have a for_unit scope that takes unit_id as parameter" do
      assert_equal 3, Officer.for_unit(@major_crimes).count
      assert_equal [@jazeveda, @jblake, @msawyer], Officer.for_unit(@major_crimes).to_a.sort_by{|o| o.last_name}
    end

    should "have a search scope that takes name fragment as parameter" do
      assert_equal 2, Officer.search("jo").count
      assert_equal [@jazeveda, @jblake], Officer.search("jo").to_a.sort_by{|o| o.last_name}
      assert_equal [@jgordon], Officer.search("go").to_a
    end

    should "shows name as last, first name" do
      assert_equal "Blake, John", @jblake.name
    end   
    
    should "shows proper name as first and last name" do
      assert_equal "John Blake", @jblake.proper_name
    end 

    should "shows that Jim Gordon's ssn is stripped of non-digits" do
      assert_equal "064230511", @jgordon.ssn
    end

    should "show that current_assignments for officer with no assignments is nil" do
      create_investigations
      create_assignments
      assert_nil @jgordon.current_assignments  # never had an assignment
      assert_nil @msawyer.current_assignments  # old assignment finished
    end

    should "return current_assignments for officer with assignments" do
      create_investigations
      create_assignments
      assert_equal [@lacey_jblake], @jblake.current_assignments  # had two assignments; one finished and one current
      assert_equal [@harbor_jazeveda], @jazeveda.current_assignments  # only has one (current) assignment ever
    end

    should "identify placing officer in a non-active unit is invalid" do
      bad_officer_unit = FactoryBot.build(:officer, first_name: "Gil", last_name: "Loeb", rank: "Captain", username: "jgordon", unit: @section_31)
      deny bad_officer_unit.valid?
      ghost_officer_unit = FactoryBot.build(:officer, first_name: "Gil", last_name: "Loeb", rank: "Captain", username: "gloeb", unit: nil)
      deny ghost_officer_unit.valid?
    end

    should "be able destroy officers without assignments" do
      create_investigations
      create_assignments
      assert @jgordon.destroy
    end

    should "not destroy officers with assignments but can be made inactive" do
      create_investigations
      create_assignments
      # Blake and Sawyer are active now
      assert @jblake.active
      assert @msawyer.active
      # assert that Blake has current assignments
      deny @jblake.assignments.current.empty?
      # attempt to destroy fails
      deny @jblake.destroy  # has current assignments
      deny @msawyer.destroy  # has only past assignments
      @jblake.reload
      @msawyer.reload
      # verify now inactive
      deny @jblake.active
      deny @msawyer.active
      # verify no current assignments for Blake
      assert @jblake.assignments.current.empty?
    end

    should "not be made inactive for a bad edit" do
      assert @jblake.active
      @jblake.last_name = nil
      deny @jblake.valid?
      deny @jblake.save
      assert @jblake.active
    end

    should "terminate assignments of inactive officers" do
      create_investigations
      create_assignments
      assert_equal 1, @jblake.assignments.current.count
      @jblake.make_inactive
      @jblake.reload
      deny @jblake.active
      assert_equal 0, @jblake.assignments.current.count
    end

    should "require users to have unique, case-insensitive usernames" do
      assert_equal "jblake", @jblake.username
      @jblake.username = "JGordon"
      deny @jblake.valid?, "UN: #{@jblake.username}"
    end

    should "require a password for new users" do
      bad_user = FactoryBot.build(:officer, first_name: "Mark", username: "mark", last_name: "Heimann", role: "officer", password: nil)
      deny bad_user.valid?
    end

    should "require passwords to be confirmed and matching" do
      bad_user_1 = FactoryBot.build(:officer, first_name: "Mark", username: "mark", last_name: "Heimann", role: "officer", password: "secret", password_confirmation: nil)
      deny bad_user_1.valid?
      bad_user_2 = FactoryBot.build(:officer, first_name: "Mark", username: "mark", last_name: "Heimann", role: "officer", password: "secret", password_confirmation: "sauce")
      deny bad_user_2.valid?
    end

    should "require passwords to be at least four characters" do
      bad_user = FactoryBot.build(:officer, first_name: "Mark", username: "mark", last_name: "Heimann", role: "officer", password: "non", password_confirmation: "non")
      deny bad_user.valid?
    end

    should "have class method to handle authentication services" do
      assert Officer.authenticate('jblake', 'secret')
      deny Officer.authenticate('jblake', 'notsecret')
    end

    should "have role methods and recognize all three roles" do
      assert @jblake.role?(:officer)
      deny @jblake.role?(:chief)
      deny @jblake.role?(:commish)
      deny @msawyer.role?(:officer)
      assert @msawyer.role?(:chief)
      deny @msawyer.role?(:commish)
      deny @jgordon.role?(:officer)
      deny @jgordon.role?(:chief)
      assert @jgordon.role?(:commish)
    end

  end
end

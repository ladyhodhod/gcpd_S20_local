require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "Within context" do
    should "verify the abilities of commish users to do everything" do
      create_commish_abilities
      assert @jgordon_ability.can? :manage, :all
    end

    should "verify the abilities of chief users in GCPD" do
      create_chief_abilities
      # no global privileges
      deny @msawyer_ability.can? :manage, :all
      # testing particular abilities
      assert @msawyer_ability.can? :read, :all
      assert @msawyer_ability.can? :manage, Investigation
      assert @msawyer_ability.can? :manage, InvestigationNote
      assert @msawyer_ability.can? :manage, CrimeInvestigation
      assert @msawyer_ability.can? :manage, Assignment
      assert @msawyer_ability.can? :read, Unit
      assert @msawyer_ability.can? :create, Officer
      assert @msawyer_ability.can? :update, @major_crimes
      deny @msawyer_ability.can? :update, @homicide
      assert @msawyer_ability.can? :manage, @jblake
      deny @msawyer_ability.can? :manage, @jgordon
    end

    should "verify the abilities of officer users in GCPD" do
      create_officer_abilities
      # no global privileges
      deny @jblake_ability.can? :manage, :all
      # testing particular abilities
      assert @jblake_ability.can? :read, Investigation
      assert @jblake_ability.can? :new, Investigation
      assert @jblake_ability.can? :create, Investigation
      assert @jblake_ability.can? :update, @lacey
      deny @jblake_ability.can? :update, @pussyfoot
      assert @jblake_ability.can? :manage, InvestigationNote
      assert @jblake_ability.can? :read, Assignment
      assert @jblake_ability.can? :read, Crime
      assert @jblake_ability.can? :manage, CrimeInvestigation
      assert @jblake_ability.can? :read, @jblake
      deny @jblake_ability.can? :read, @msawyer
      assert @jblake_ability.can? :update, @jblake
      deny @jblake_ability.can? :update, @msawyer
      assert @jblake_ability.can? :index, Unit
      assert @jblake_ability.can? :show, @major_crimes
      deny @jblake_ability.can? :show, @homicide
    end

  end
end
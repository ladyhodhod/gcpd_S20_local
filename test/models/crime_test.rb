require 'test_helper'

class CrimeTest < ActiveSupport::TestCase

  # Context
  context "Within context" do
    setup do
      create_crimes
    end

    should "have active and inactive scopes" do
      assert_equal 4, Crime.active.count
      assert_equal [@arson, @murder, @robbery, @trespass], Crime.active.to_a.sort_by{|c| c.name}
      assert_equal 1, Crime.inactive.count
      assert_equal [@murder2], Crime.inactive.to_a
    end

    should "have make_active and make_inactive methods" do
      assert @arson.active
      @arson.make_inactive
      @arson.reload
      deny @arson.active
      @arson.make_active
      @arson.reload
      assert @arson.active
    end

    should "never be destroyed" do
      deny @arson.destroy
    end
  end
end

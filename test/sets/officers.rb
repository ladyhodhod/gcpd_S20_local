module Contexts
  module Officers

    def create_officers
      @jblake   = FactoryBot.create(:officer, unit: @major_crimes)
      @jgordon  = FactoryBot.create(:officer, first_name: "Jim", last_name: "Gordon", rank: "Commissioner", username:"jgordon", role: "commish", unit: @headquarters, ssn: "064-23-0511")
      @msawyer  = FactoryBot.create(:officer, first_name: "Maggie", last_name: "Sawyer", rank: "Captain", role: "chief", username: "msawyer", unit: @major_crimes)
      @gloeb    = FactoryBot.create(:officer, first_name: "Gillian", last_name: "Loeb", rank: "Commissioner", username: "gloeb", role: "commish", unit: @headquarters, active: false)
      @jazeveda = FactoryBot.create(:officer, first_name: "Josh", last_name: "Azeveda", rank: "Detective", username: "jazeveda", role: "officer", unit: @major_crimes)
    end

  end
end
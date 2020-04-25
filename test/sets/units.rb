module Contexts
  module Units

    def create_units
      @major_crimes = FactoryBot.create(:unit)
      @headquarters = FactoryBot.create(:unit, name: "Headquarters")
      @homicide     = FactoryBot.create(:unit, name: "Homicide")
      @section_31   = FactoryBot.create(:unit, name: "Section 31", active: false)
    end

  end
end
require 'rails_helper'

RSpec.describe Organization, :type => :model do

   describe "#new" do
    context 'with invalid parameters' do
      it "doesn't create anything" do
        #Setup
        Organization.create()
        
        #Expectation
        expect(Organization.all.size).to eq(0)
      end
    end

    context "with valid parameters" do
      it "creates a membership" do
        #Setup
        Organization.create(name: "Workers")

        #Expectation
        expect(Organization.where(name: "Workers")).to be_truthy
      end
    end
  end

  describe "#set_all_unpaired" do
    it "sets all people's paired attribute to false" do
      #Setup
      Organization.create(name: "Workers")
      Person.create( name: "Bob", email: "Bob@gmail.com", paired: true )
      Organization.first.set_all_unpaired

      #Expectation
      expect(Person.find_by(name: "Bob").paired).to be false
    end
  end

  describe "#fewest_teammates" do
    it "returns the person with the fewest teammates" do
      #Setup
      Organization.create(name: "Workers")
      teammates = {
        "Foo" => 3,
        "Bar" => 2,
        "Baz" => 5
      }
      expect(Organization.first.fewest_teammates(teammates)).to eq("Bar")
    end
  end

end

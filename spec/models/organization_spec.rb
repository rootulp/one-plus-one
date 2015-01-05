require 'rails_helper'

RSpec.describe Organization, :type => :model do

  describe "#reset_paired" do
    it "sets all people's paired attribute to false" do
      #Setup
      Organization.create(name: "Workers")
      Person.create( name: "Bob", email: "Bob@gmail.com", paired: true, organization: Organization.find_by(name: "Workers") )
      Organization.find_by(name: "Workers").reset_paired

      #Expectation
      expect(Person.find_by(name: "Bob").paired).to be false
    end
  end

  describe "#fewest_potential_pairs" do
    it "returns the person with the fewest teammates" do
      #Setup
      Organization.create(name: "Workers")
      teammates = {
        "Foo" => 3,
        "Bar" => 2,
        "Baz" => 5
      }
      expect(Organization.find_by(name: "Workers").fewest_potential_pairs(teammates)).to eq("Bar")
    end
  end

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
      it "creates an organization" do
        #Setup
        Organization.create(name: "Workers")

        #Expectation
        expect(Organization.find_by(name: "Workers")).to be_truthy
      end
    end
  end

  describe "#unpaired_people" do
    it "returns a hash of unpaired people and the number of their potential pairs" do
      org = Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization: org, paired: false )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization: org, paired: false )
      ron = Person.create( name: "Ron", email: "Ron@gmail.com", organization: org, paired: false, last_pair: bob )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      Membership.create(team: builders, person: ron)

      expect(org.unpaired_people).to eq({bob => 2, tom => 2, ron => 1})
    end
  end

  describe "#next_unpaired" do
    it "returns the person with the fewest_potential_pairs" do
      org = Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization: org, paired: false )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization: org, paired: false )
      ron = Person.create( name: "Ron", email: "Ron@gmail.com", organization: org, paired: false, last_pair: bob )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      Membership.create(team: builders, person: ron)

      expect(org.next_unpaired).to eq(ron)
    end
  end

end

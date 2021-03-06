require 'rails_helper'

RSpec.describe Organization, :type => :model do

  describe "#reset_flags" do
    it "sets all people's paired attribute to false" do
      Organization.create(name: "Workers")
      Person.create( name: "Bob", email: "Bob@gmail.com", paired: true, organization: Organization.find_by(name: "Workers") )
      Organization.find_by(name: "Workers").reset_flags

      expect(Person.find_by(name: "Bob").paired).to be false
    end

    it "sets all people's attempted attribute to false" do
      Organization.create(name: "Workers")
      Person.create( name: "Bob", email: "Bob@gmail.com", attempted: true, organization: Organization.find_by(name: "Workers") )
      Organization.find_by(name: "Workers").reset_flags

      expect(Person.find_by(name: "Bob").attempted).to be false
    end
  end

  describe "#fewest_potential_pairs" do
    it "returns the person with the fewest teammates" do
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
          Organization.create()
        
          expect(Organization.all.size).to eq(0)
      end
    end

    context "with valid parameters" do
      it "creates an organization" do
          Organization.create(name: "Workers")

          expect(Organization.find_by(name: "Workers")).to be_truthy
      end
    end
  end

  describe "#unattempted_people" do
    it "returns a hash of unattempted people and the number of their potential pairs" do
      org = Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      wizards = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization: org )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization: org )
      ron = Person.create( name: "Ron", email: "Ron@gmail.com", organization: org )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      Membership.create(team: wizards, person: ron)

      expect(org.unattempted_people).to eq({bob => 1, tom => 1, ron => 0})
    end
  end

  describe "#next_unattempted" do
    it "returns the person with the fewest_potential_pairs" do
      org = Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      wizards = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization: org )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization: org )
      ron = Person.create( name: "Ron", email: "Ron@gmail.com", organization: org )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      Membership.create(team: wizards, person: ron)

      expect(org.next_unattempted).to eq(ron)
    end
  end

end

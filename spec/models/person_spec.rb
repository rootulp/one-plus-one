require 'rails_helper'

RSpec.describe Person, :type => :model do

  describe "#mark_attempt" do

    it "sets attempted to true" do
      Organization.create(name: "Workers")
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1, attempted: false )
      bob.mark_attempt

      expect(bob.attempted).to be true
    end
  end

  describe "#potential_pairs" do
    it "doesn't include self" do
      Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1 )
      Membership.create(team: builders, person: bob)
      
      expect(bob.potential_pairs).to be_empty
    end

    it "doesn't include paired people" do
      Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization_id: 1, paired: true )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1 )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      
      expect(bob.potential_pairs).to be_empty
    end

    it "does include valid potential pairs" do
      Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization_id: 1 )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1 )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      
      expect(bob.potential_pairs).to include(tom)
    end
  end

  describe "#num_potential_pairs" do
    it "accuratly counts number of potential pairs" do
      Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization_id: 1 )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1 )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      
      expect(bob.num_potential_pairs).to eq(1)
    end
  end

  describe "#find_pair" do
    it "returns false if no potential pairs" do
      Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1 )
      Membership.create(team: builders, person: bob)

      expect(bob.find_pair).to be false
    end

    it "returns a pair if one exists" do
      Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization_id: 1 )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1 )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)

      expect(bob.find_pair).to eq tom
    end
  end

end

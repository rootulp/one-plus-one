require 'rails_helper'

RSpec.describe Person, :type => :model do

  describe "#update_solo" do

    it "sets paired to true" do
      #Setup
      Organization.create(name: "Workers")
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1, paired: false )
      bob.update_solo

      #Expectation
      expect(bob.paired).to be true
    end

    it "sets last_pair to false" do
      #Setup
      Organization.create(name: "Workers")
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1, last_pair_id: 3 )
      bob.update_solo

      #Expectation
      expect(bob.last_pair).to be false
    end

  end

  describe "#update_pair" do

    it "sets paired to true" do
      #Setup
      Organization.create(name: "Workers")
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1, paired: false )
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization_id: 1, paired: false )
      bob.update_pair(tom)

      #Expectation
      expect(bob.paired).to be true
    end

    it "sets last_pair to partner" do
      #Setup
      Organization.create(name: "Workers")
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1, last_pair: false )
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization_id: 1 )
      bob.update_pair(tom)

      #Expectation
      expect(bob.last_pair).to be tom
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

    it "doesn't include last pair" do
      Organization.create(name: "Workers")
      builders = Team.create(name: "Builders")
      tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization_id: 1 )
      bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization_id: 1, last_pair: tom )
      Membership.create(team: builders, person: bob)
      Membership.create(team: builders, person: tom)
      
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

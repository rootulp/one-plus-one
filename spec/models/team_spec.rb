require 'rails_helper'

RSpec.describe Team, :type => :model do
  describe "#members" do
    
    context 'for team 1' do
      it "returns team 1 members" do
        org = Organization.create(name: "Workers")
        builders = Team.create(name: "Builders")
        bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization: org )
        tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization: org )
        Membership.create(team: builders, person: bob)
        Membership.create(team: builders, person: tom)

        expect(builders.members).to include(bob)
        expect(builders.members).to include(tom)
      end
    end

    context 'not members' do
      it "returns non members" do
        org = Organization.create(name: "Workers")
        builders = Team.create(name: "Builders", organization: org)
        crafters = Team.create(name: "Crafters", organization: org)
        bob = Person.create( name: "Bob", email: "Bob@gmail.com", organization: org )
        tom = Person.create( name: "Tom", email: "Tom@gmail.com", organization: org )
        Membership.create(team: builders, person: bob)
        Membership.create(team: crafters, person: tom)

        expect(builders.not_members.to_a).to include(tom)
        expect(crafters.not_members.to_a).to include(bob)
      end
    end

  end
end

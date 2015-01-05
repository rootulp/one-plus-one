require 'rails_helper'

RSpec.describe Membership, :type => :model do
  
  describe "#new" do

    context 'with invalid parameters' do
      it "doesn't create anything" do
        #Setup
        Membership.create()
        
        #Expectation
        expect(Membership.all.size).to eq(0)
      end
    end

    context "with valid parameters" do
      it "creates a membership" do
        #Setup
        Person.create( name: "Bob", email: "Bob@gmail.com" )
        Team.create( name: "Builders" )
        Membership.create( team: Team.find_by(name: "Builders"), person: Person.find_by(name: "Bob"))

        #Expectation
        expect(Membership.where(team_id: 1, person_id: 1)).to be_truthy
      end
    end

    context 'with duplicate membership creations' do
      it "only creates one" do
        #Setup
        Person.create( name: "Bob", email: "Bob@gmail.com" )
        Team.create( name: "Builders" )
        Membership.create( team: Team.find_by(name: "Builders"), person: Person.find_by(name: "Bob"))
        Membership.create( team: Team.find_by(name: "Builders"), person: Person.find_by(name: "Bob"))
        
        #Expectation
        expect(Membership.all.size).to eq(1)
      end
    end

  end

end

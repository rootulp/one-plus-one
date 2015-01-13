require 'rails_helper'

RSpec.describe Relationship, :type => :model do
  describe "#relationships_for" do
    
    context 'invalid week' do
      it "returns empty" do
        expect(Relationship.relationships_for(9)).to eq([])
      end
    end

    context 'valid week' do
      it "returns relationships" do
        bob = Person.create( name: "Bob", email: "Bob@gmail.com" )
        tom = Person.create( name: "Tom", email: "Tom@gmail.com" )
        a = Relationship.create(partner1: bob, partner2: tom, week: 3)

        expect(Relationship.relationships_for(3).to_a).to eq([a])
      end
    end

  end
end

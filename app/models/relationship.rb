class Relationship < ActiveRecord::Base
  
  belongs_to :partner1, class_name: "Person"
  belongs_to :partner2, class_name: "Person"

  validates :partner1_id, presence: true
  validates :partner2_id, presence: true

  after_create do |relationship|
    Person.find_by(id: relationship.partner1_id).update(paired: true, attempted: true)
    Person.find_by(id: relationship.partner2_id).update(paired: true, attempted: true)
  end

  def self.relationships_for(week)
    Relationship.where(week: week)
  end

end

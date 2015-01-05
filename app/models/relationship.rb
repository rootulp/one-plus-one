class Relationship < ActiveRecord::Base
  
  belongs_to :partner1, class_name: "Person"
  belongs_to :partner2, class_name: "Person"

  validates :partner1_id, presence: true
  validates :partner2_id, presence: true
end

class Membership < ActiveRecord::Base
  belongs_to :team
  belongs_to :person

  validates_associated :team
  validates_associated :person
  validates_uniqueness_of :person_id, :scope => :team_id
end

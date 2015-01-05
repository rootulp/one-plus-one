class Membership < ActiveRecord::Base

  belongs_to :team
  belongs_to :person

  validates :team, presence: true
  validates :person, presence: true
  validates_associated :team
  validates_associated :person

  # Attempt at making sure duplicate memberships aren't created
  validates_uniqueness_of :person_id, :scope => :team_id

end

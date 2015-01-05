class Team < ActiveRecord::Base

  belongs_to :organization

  has_many :memberships
  has_many :people, :through => :memberships

  validates :name, presence: true

  def members
    self.people
  end

  def not_members
    Person.all - self.people
  end
end

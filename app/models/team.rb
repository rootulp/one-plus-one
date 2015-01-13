class Team < ActiveRecord::Base

  belongs_to :organization

  has_many :memberships, dependent: :destroy
  has_many :people, :through => :memberships

  validates :name, presence: true, uniqueness: { case_sensitive: false }

  def members
    self.people
  end

  def not_members
    Person.where(organization: self.organization) - self.members
  end
end

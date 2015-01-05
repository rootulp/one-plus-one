class Person < ActiveRecord::Base

  belongs_to :organization

  has_many :memberships
  has_many :teams, :through => :memberships

  validates :email, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def potential_teammates
    teammates = []
    self.teams.each do |team|
      team.members.each do |member|
        if member != self && member.paired == false
          teammates << member 
        end
      end
    end
    teammates
  end

  def num_potential_teamates
    self.potential_teammates.size
  end

  def find_pair
    return false if self.potential_teammates.empty?
    self.potential_teammates.sample
  end

end

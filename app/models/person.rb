class Person < ActiveRecord::Base
  has_many :memberships
  has_many :teams, :through => :memberships

  validates :email, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def unmatched_teammates
    teammates = []
    self.teams.each do |team|
      team.people.each do |member|
        if member != self && member.paired == false
          teammates << member 
        end
      end
    end
    teammates
  end

  def find_pair
    return false if self.unmatched_teammates.empty?
    self.unmatched_teammates.sample
  end

end

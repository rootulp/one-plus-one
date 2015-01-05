class Person < ActiveRecord::Base

  belongs_to :organization
  belongs_to :last_pair, class_name: 'Person'

  has_many :memberships
  has_many :teams, :through => :memberships

  validates :email, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  def potential_teammates
    teammates = []
    self.teams.each do |team|
      team.members.each do |member|
        if self != member && self.last_pair != member && member.paired == false
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

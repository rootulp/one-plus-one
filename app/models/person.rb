class Person < ActiveRecord::Base

  belongs_to :organization
  belongs_to :last_pair, class_name: 'Person'

  has_many :memberships
  has_many :teams, :through => :memberships

  validates :email, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # Returns array of potential pairs
  def potential_pairs
    potential_pairs = []
    self.teams.each do |team|
      team.members.each do |member|
        if self != member && self.last_pair != member && member.paired == false
          potential_pairs << member 
        end
      end
    end
    potential_pairs
  end

  # Returns num of potential pairs
  def num_potential_pairs
    self.potential_pairs.size
  end

  # Randomly selects a pair or returns false if no pairs exist
  def find_pair
    return false if self.potential_pairs.empty?
    self.potential_pairs.sample
  end

end

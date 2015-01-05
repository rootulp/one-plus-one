class Person < ActiveRecord::Base

  belongs_to :organization

  has_many :memberships, dependent: :destroy
  has_many :teams, :through => :memberships

  has_many :relationships, class_name: "Relationship", foreign_key: "partner1_id", dependent: :destroy
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "partner2_id", dependent: :destroy
  has_many :pairs, through: :relationships, source: :partner2
  has_many :reverse_pairs, through: :reverse_relationships, source: :partner1

  validates :email, presence: true, uniqueness: { case_sensitive: false }
  validates :name, presence: true

  # Returns array of potential pairs
  def potential_pairs
    potentials = []
    teams.each do |team|
      team.members.each do |member|
        if member != self && member != self.last_pair && member.paired == false
          potentials << member
        end
      end
    end
    potentials
  end

  # Returns num of potential pairs
  def num_potential_pairs
    potential_pairs.size
  end

  # Randomly selects a pair or returns false if no pairs exist
  def find_pair
    return false if potential_pairs.empty?
    potential_pairs.sample
  end

  # Create relationship between self and pair
  def pair_up(pair, week)
    relationships.create!(partner2_id: pair.id, week: week)
  end

  def mark_attempt
    self.update(attempted: true)
  end

  # Returns array of all previous pairs
  def all_pairs
    all_pairs = self.pairs + self.reverse_pairs
    all_pairs.uniq!
  end

  # Returns relationship from last week or false if not paired
  def last_relationship
    week = Organization.first.last_week
    relationship = self.relationships.find_by(week: week) || self.reverse_relationships.find_by(week: week)
  end

  # Returns pair from last week or false if not paired
  def last_pair
    week = Organization.first.last_week
    return false unless last_relationship
    if self.id != last_relationship.partner1_id
      Person.find_by(id: last_relationship.partner1_id) 
    else
      Person.find_by(id: last_relationship.partner2_id)
    end
  end

end

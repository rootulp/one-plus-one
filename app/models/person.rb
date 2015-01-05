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
  def valid_pair(member)
    return true if member != self && member != last_pair && member.paired == false
    false
  end

  def potential_pairs
    potential_pairs = []
    teams.each do |team|
      team.members.each do |member|
        potential_pairs << member if valid_pair(member)
      end
    end
    potential_pairs
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

  def pair_up(pair, week)
    relationships.create!(partner2_id: pair.id, week: week)
  end

  def mark_attempt
    self.update(attempted: true)
  end

  def all_pairs
    all_pairs = self.pairs + self.reverse_pairs
    all_pairs.uniq!
  end

  def last_relationship
    relationship_for(Organization.first.last_week)
  end

  def last_pair
    pair_for(Organization.first.last_week)
  end

  def relationship_for(week)
    relationship = self.relationships.find_by(week: week) || self.reverse_relationships.find_by(week: week)
  end

  def pair_for(week)
    return false unless relationship_for(week)
    if self.id != relationship_for(week).partner1_id
      Person.find_by(id: relationship_for(week).partner1_id) 
    else
      Person.find_by(id: relationship_for(week).partner2_id)
    end
  end

end

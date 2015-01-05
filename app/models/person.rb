class Person < ActiveRecord::Base

  belongs_to :organization
  belongs_to :last_pair, class_name: 'Person'

  has_many :memberships, dependent: :destroy
  has_many :teams, :through => :memberships

  has_many :relationships, class_name: "Relationship", foreign_key: "partner1_id", dependent: :destroy
  has_many :reverse_relationships, class_name: "Relationship", foreign_key: "partner2_id", dependent: :destroy
  has_many :pairs, through: :relationships, source: :partner2
  has_many :reverse_pairs, through: :relationships, source: :partner1

  validates :email, presence: true, uniqueness: { case_sensitive: false }
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

  # Updates paired attribute to true and clears last_pair
  def update_solo
    self.update(paired: true, last_pair: false)
  end

  # Updates paired attribute to true and last_pair to the current pair
  def update_pair(other_person)
    self.update(paired: true, last_pair: other_person)
  end

  def pair_up(other_person, week)
    relationships.create!(partner2_id: other_person.id, week: week)
  end

end

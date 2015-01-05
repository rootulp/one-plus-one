class Organization < ActiveRecord::Base
  attr_reader :pairs

  has_many :teams
  has_many :people

  validates :name, presence: true

  def generate_pairings
    reset_flags
    
    while next_unattempted
      current = next_unattempted
      current.pair_up(current.find_pair, current_week) if current.find_pair
      current.mark_attempt
    end
  end

  # Returns the next unattempted person with the fewest potential pairs
  def next_unattempted
    fewest_potential_pairs(unattempted_people)
  end

  # Returns hash of unattempted people and the number of potential pairs they have
  def unattempted_people
    unattempted = {}
    people.where(attempted: false).each do |person|
      unattempted[person] = person.num_potential_pairs
    end
    unattempted
  end

  # Returns the key for the lowest value in the hash
  # In this case, returns the person with the fewest potential pairs
  def fewest_potential_pairs(hash)
    person, num_potential_pairs = hash.min_by{ |key, value| value }
    person
  end

  # Set paired attribute to false for all ppl in organization
  def reset_flags
    self.people.update_all(paired: false, attempted: false)
  end

  def pairs_for(week)
    pairs = []
    relationships = Relationship.relationships_for(week)
    relationships.each do |relationship|
      pairs << [Person.find_by(id: relationship.partner1_id), Person.find_by(id: relationship.partner2_id)]
    end
    pairs
  end

  def unpaired_for(week)
    self.people - pairs_for(week).flatten
  end

  def current_week
    self.week.to_i
  end

  def last_week
    self.week.to_i - 1
  end

end

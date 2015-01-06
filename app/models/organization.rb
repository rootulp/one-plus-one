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

    pair_leftovers if leftovers?
  end

  # Are there any unpaired people left?
  def leftovers?
    people.where(paired: false).size > 1
  end

  # Pair up people without pairs (doesn't satisfy same team rule)
  def pair_leftovers
    current, pair = people.where(paired: false).take(2)
    current.pair_up(pair, current_week)
    pair_leftovers if leftovers?
  end

  # Returns the unattempted person with the fewest potential pairs
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

  # Set paired and attempted attributes to false for all ppl in organization
  def reset_flags
    self.people.update_all(paired: false, attempted: false)
  end

  # Retrieve relationships for a given week, pull out people and toss into array
  def pairs_for(week)
    pairs = []
    relationships = Relationship.relationships_for(week)
    relationships.each do |relationship|
      pairs << [Person.find_by(id: relationship.partner1_id), Person.find_by(id: relationship.partner2_id)]
    end
    pairs
  end

  # Retrieve ppl who weren't paired for a given week
  def unpaired_for(week)
    self.people - pairs_for(week).flatten
  end

  # I don't like having week be a property of organization but wasn't sure where else to put it
  def current_week
    self.week.to_i
  end

  def last_week
    self.week.to_i - 1
  end

end

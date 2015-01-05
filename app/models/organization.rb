class Organization < ActiveRecord::Base

  has_many :teams
  has_many :people

  validates :name, presence: true

  # Returns array of pairs for the week
  def pairs
    reset_paired
    
    pairs = []
    while next_unpaired
      person1 = next_unpaired
      person2 = person1.find_pair
      
      if person2
        person1.update_pair(person2)
        person2.update_pair(person1)
      else
        person1.update_solo
      end

      pairs << [person1, person2]
    end
    
    pairs
  end

  # Returns the next unpaired teammate with the fewest potential pairs
  def next_unpaired
    fewest_potential_pairs(unpaired_people)
  end

  # Returns hash of unpaired people and the number of potential pairs they have
  def unpaired_people
    unpaired = {}
    people.where(paired: false).each do |person|
      unpaired[person] = person.num_potential_pairs
    end
    unpaired
  end

  # Returns the key for the lowest value in the hash
  # In this case, returns the person with the fewest pairs
  def fewest_potential_pairs(hash)
    person, num_pairs = hash.min_by{ |key, value| value }
    person
  end

  # Set paired attribute to false for all ppl in organization
  def reset_paired
    self.people.update_all(paired: false)
  end

end

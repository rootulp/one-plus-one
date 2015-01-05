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
       
      update_pair(person1, person2) if person2
      update_solo(person1) unless person2

      pairs << [person1, person2]
    end
    
    pairs
  end

  # Sets paired attribute to true and clears last_pair
  def update_solo(person1)
    person1.update(paired: true, last_pair: nil)
  end

  # Sets paired and last_pair attributes for person1 and person2
  def update_pair(person1, person2)
    person1.update(paired: true, last_pair: person2)
    person2.update(paired: true, last_pair: person1)
  end

  # Returns the next unpaired teammate with the fewest potential teammates
  def next_unpaired
    fewest_teammates(unpaired_people)
  end

  # Returns hash of unpaired people and the number of potential teammates they have
  def unpaired_people
    unpaired = {}
    Person.where(paired: false, organization: self).each do |person|
      unpaired[person] = person.num_potential_pairs
    end
    unpaired
  end

  # Returns the key for the lowest value in the hash
  # In this case, returns the person with the fewest teammates
  def fewest_teammates(hash)
    person, num_pairs = hash.min_by{ |key, value| value }
    person
  end

  # Set paired attribute to false for all ppl in organization
  def reset_paired
    Person.where(organization: self).update_all(paired: false)
  end

end

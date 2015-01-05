class Organization < ActiveRecord::Base

  has_many :teams
  has_many :people

  validates :name, presence: true

  def pairs
    reset_unpaired
    
    pairs = []
    
    while next_unpaired
      person1 = next_unpaired
       
      if person1.find_pair
        person2 = person1.find_pair
        person1.update(paired: true, last_pair: person2)
        person2.update(paired: true, last_pair: person1)
        pairs << [person1, person2]
      else
        person1.update(paired: true, last_pair: nil)
        pairs << [person1, "NO MATCH"]
      end
    end
    
    pairs
  end

  def next_unpaired
    fewest_teammates(unpaired_people)
  end

  def unpaired_people
    people_and_num_teammates = {}
    Person.where(paired: false, organization: self).each do |person|
      people_and_num_teammates[person] = person.num_potential_teamates
    end
    people_and_num_teammates
  end

  def fewest_teammates(hash)
    person, num_teammates = hash.min_by{ |key, value| value }
    person
  end

  def reset_unpaired
    Person.where(organization: self).update_all(paired: false)
  end

end

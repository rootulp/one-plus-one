class Organization < ActiveRecord::Base
  has_many :teams

  validates :name, presence: true

  def weekly_pairing
    set_all_unpaired
    
    results = []
    
    while next_unpaired
      person1 = next_unpaired
       
      if person1.find_pair
        person2 = person1.find_pair
        person1.update(paired: true)
        person2.update(paired: true)
        results << [person1.name, person2.name]
      else
        person1.update(paired: true)
        results << [person1.name, "NO MATCH"]
      end
    end
    
    results
  end

  def next_unpaired
    Person.find_by(paired: false)
  end

  def set_all_unpaired
    Person.update_all(paired: false)
  end

end

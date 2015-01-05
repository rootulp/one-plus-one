people = [
  [ "Paul McCartney", "paul@mccartney.org" ],
  [ "John Lennon", "john@lennon.com" ],
  [ "George Harrison", "george@harrison.org" ],
  [ "Ringo Starr", "ringo@starr.org" ],
  [ "Stu Sutcliffe", "stu@sutcliffe.org" ],
  [ "Linda McCartney", "linda@mccartney.org"],
  [ "Yoko Ono", "yoko@ono.org"],
  [ "Tom Petty", "tom@petty.org"],
  [ "Roy Orbison", "roy@orbison.org"]
]

teams = ["The Beatles", "The Quarrymen", "Wings", "Plastic Ono Band", "Traveling Wilburys"]

memberships = [
  [ "The Beatles", "Paul McCartney" ],
  [ "The Beatles", "John Lennon" ],
  [ "The Beatles", "George Harrison" ],
  [ "The Beatles", "Ringo Starr" ],
  [ "The Quarrymen", "Paul McCartney" ],
  [ "The Quarrymen", "John Lennon" ],
  [ "The Quarrymen", "Stu Sutcliffe" ], 
  [ "Wings", "Paul McCartney"],
  [ "Wings", "Linda McCartney"],
  [ "Plastic Ono Band", "John Lennon"],
  [ "Plastic Ono Band", "Yoko Ono"],
  [ "Traveling Wilburys", "George Harrison"],
  [ "Traveling Wilburys", "Tom Petty"],
  [ "Traveling Wilburys", "Roy Orbison"]
]

Organization.create( name: "Musicians")

teams.each do |name|
  Team.create( name: name, organization: Organization.find_by(name: "Musicians") )
end

people.each do |name, email|
  Person.create( name: name, email: email )
end

memberships.each do |team, name|
  Membership.create( team: Team.find_by(name: team), person: Person.find_by(name: name) )
end
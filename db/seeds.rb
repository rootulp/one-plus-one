people = [
  [ "Paul McCartney", "paul@mccartney.org" ],
  [ "John Lennon", "john@lennon.com" ],
  [ "George Harrison", "george@harrison.org" ],
  [ "Ringo Starr", "ringo@starr.org" ],
  [ "Stu Sutcliffe", "stu@sutcliffe.org" ]
]

teams = ["The Beatles", "The Quarrymen"]

memberships = [
  [ "The Beatles", "Paul McCartney" ],
  [ "The Beatles", "John Lennon" ],
  [ "The Beatles", "George Harrison" ],
  [ "The Beatles", "Ringo Starr" ],
  [ "The Quarrymen", "Paul McCartney" ],
  [ "The Quarrymen", "John Lennon" ],
  [ "The Quarrymen", "Stu Sutcliffe" ]
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
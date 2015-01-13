# One Plus One

### What is it?
One plus one is a small rails app used to create weekly pairings between teammates in an organization.

### How to use it?
The project is hosted on [Heroku](https://one--plus--one.herokuapp.com/)  
Optional - Run Locally:  
1. <code>git clone</code> this repo  
2. run <code> bundle install </code>  
3. run rake db commands  
4. start <code> rails server</code>  
5. optional: run tests with <code> bundle exec rspec </code>

### Strategy for Pairings
The pairing algorithm I used has undergone several iterations. It started with selecting completely random pairs of people in the organization. Then I implemented teams and selected random pairs of teammates. Once that worked, I realized that the sample data had a few outliers (Yoko Ono, and Linda McCartney) who had just one potential pair each. In the current system, they'd rarely get paired because the people with more teammates were more likely to get paired before them. I choose to account for this by starting to pair people based on how few potential pairs they had left. The efficiency of the algorithm kind-of took a hit here as a hash of people along with their number of potential pairs had to be rebuilt upon every iteration of the pairing algorithm but this resulted in fewer **NO PAIR**'s so I was satisfied. 

The next task was to satisfy the **consecutive weeks** rule. The simplest solution I could think of was to add a last_pair attribute to every person. This way, the pairing algorithm could compare potential pairs to the last pair of an individual and eliminate consecutive week pairs. This worked surprisingly well until I remembered the last rule imposing **equal frequency**. This meant that I would need to keep track of more than just the last_pair for every person. Suddenly my solution didn't seem very practical. 

I turned to the internet to see if anyone had faced a similar data modeling issue and found Michael Hartl's *Ruby on Rails Tutorial Book*. Hartl describes the peculiar follower & followed relationship and suggests abstracting this pairing information to a separate table. I used his advice and parts of his code to create a relationship table that would store pairings for each week. The transition to the new algorithm resulted in a lot of sloppy code. Running time also took a hit because several relationship records had to be pulled up per iteration.

At this point I considered reverting back to a commit before I built the relationship table. I decided against it to preserve the history of the project and because I think I can learn more from refactoring the current code. I also decided against implementing the equal frequency rule because the sample data would result in a ton of **NO PAIR**'s.

### Testing
I have very limited experience with RSpec and testing in general so I took this challenge as an opportunity to get my feet wet. Sadly I didn't do any TDD but I definitely learned a little about testing. I focused on testing the Person and Organization instance methods but this proved difficult because the pairing algorithm was changing so frequently.

### Interesting Learning
- RSpec and testing
- First project with [Suspenders](https://github.com/thoughtbot/suspenders)
- Importance of Seed file
- Reverse relationships
- Active Record callbacks
- <code>git revert</code> and <code>git reset</code>
- <code>validates_uniqueness_of</code> with <code>scope</code>

### Notes
- Used scaffolded controller & views for People and Teams (would've rather not but did it for the sake of time)
- Went back and modified existing migrations and reset database (bad practice, I should stop)
- Need more tests!
- Not a whole lot of styling
- Implemented method to pair leftovers regardless of teammate rule
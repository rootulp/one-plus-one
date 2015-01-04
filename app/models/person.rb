class Person < ActiveRecord::Base
  has_many :memberships
  has_many :teams, :through => :memberships

  validates :email, uniqueness: { case_sensitive: false }
  validates :name, presence: true
end

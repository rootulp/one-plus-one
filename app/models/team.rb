class Team < ActiveRecord::Base
  belongs_to :organization
  has_many :memberships
  has_many :members, :through => :memberships

  validates :name, presence: true
end

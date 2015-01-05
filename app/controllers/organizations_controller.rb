class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :generate_pairings, :all]

  def show
    @week = @organization.current_week
    @pairs = @organization.pairs_for(@week)
    @unpaired = @organization.unpaired_for(@week)
  end

  def generate_pairings
    @organization.update(week: @organization.week + 1)
    @organization.generate_pairings
    redirect_to root_path
  end

  def all
    @week = @organization.current_week
    @all_relationships = Relationship.all
  end

  private
    def set_organization
      @organization = Organization.first
    end
end

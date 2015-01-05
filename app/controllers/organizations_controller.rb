class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show, :generate_pairings]

  def show
    @week = @organization.current_week
    @pairs = @organization.pairs_for(@week)
  end

  def generate_pairings
    @organization.generate_pairings
    redirect_to root_path
  end

  private
    def set_organization
      @organization = Organization.first
    end
end

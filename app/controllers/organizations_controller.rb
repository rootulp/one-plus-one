class OrganizationsController < ApplicationController
  before_action :set_organization, only: [:show]

  def show
  end

  private
    def set_organization
      @organization = Organization.first
    end
end

class MembershipsController < ApplicationController
  before_action :set_membership, only: [:destroy]
  before_action :set_team, only: [:new]

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(membership_params)
    # Add alerts if save fails
  end

  def destroy
    @membership.destroy
    # to-do: come up with a clever way to return to page
    redirect_to root_path
    # Add alerts if delete fails
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    # to-do: explicitly send params with correct keys
    def set_membership
      @membership = Membership.find_by(team_id: params[:format], person_id: params[:id] )
    end

    def set_team
      @team = Team.find(params[:format])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:person_id, :team_id)
    end

end

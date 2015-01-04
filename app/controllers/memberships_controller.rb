class MembershipsController < ApplicationController
  before_action :set_membership, only: [:destroy]

  def new
    @membership = Membership.new
  end

  def create
    @membership = Membership.new(membership_params)
    # Add alerts if save fails
  end

  def destroy
    @membership.destroy
    # Add alerts if delete fails
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_membership
      @membership = Membership.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def membership_params
      params.require(:membership).permit(:person_id, :team_id)
    end
    
end

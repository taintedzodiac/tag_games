class UsersController < ApplicationController

  def index
    @users = User.asc(:username)
    @teams = Team.asc(:name)

    @users_by_team = []
    @teams.each do |team|
      this_team = {team: team, users: @users.where(team: team)}
      @users_by_team << this_team
    end

    respond_to do |format|
      format.html
    end
  end

  def show
    @user = User.find(params[:id]).with(:votes)
    @votes = @user.votes.sort_by { |vote| vote.game.title }
    @undrafted = (@user.team == Team.where(name:"Undrafted").first ? true : false)
    @teams = Team.all.map { |team| [team.name, team.id] }

    @signup_counts = []
    Game.all.pluck(:platform).uniq.sort.each do |platform|
      i = 0
      @votes.each do |vote|
        i += 1 if vote.game.platform == platform
      end
      @signup_counts << { platform: platform, signup_count: i }
    end
  end

  def update
    @user = User.find(params[:id])

    # Block the action to change the user's team unless it's an admin or the new team's captain (drafting the player)
    if params[:user][:team_id] && !current_user.admin && !(current_user.captain_team == Team.find(params[:user][:team_id]))
      render(json: {type: 'user', action: 'draft_to_team', user: @user, success: false, params: params,
                    message: "#{current_user.captain_team.name} is not #{Team.find(params[:user][:team_id]).name}"})
      return
    end

    if @user.update_attributes!(user_params)
      @user.advance_draft_order if params[:user][:team_id]
      render(json: {type: 'user', action: 'draft_to_team', user: @user, success: true, params: params})
    else
      render(json: {type: 'user', action: 'draft_to_team', user: @user, success: false, params: params, message: "Unable to update the user."})
    end
  end

  private

  def user_params
    params.require(:user).permit(:team_id)
  end
end

class GamesController < ApplicationController

  def index
    @games = Game.all.sort_by {|game| game.votes.count}.reverse!
  end

  def show
    @game = Game.includes(:votes, :time_slot).find(params[:id])
    @current_user_vote = @game.votes.where(user: current_user).first if current_user

    @available_times = TimeSlot.not.in(id: Game.where(:id.ne => @game.id).pluck(:time_slot_id)).sort_by { |time_slot| time_slot.scheduled_time } # List of every time slot that isn't currently filled

    # List of players signed up for the game
    @players = {}
    # Score submissions (use cl_image_tag to display the value for each user as a key)
    @scores = {}

    # Build the teams for sorting players into
    Team.each do |team|
      @players[team.name] = []
    end

    @game.votes.each do |vote|
      @players[vote.user.team.name] << vote.user
      @scores[vote.user.username] = vote.image_id
    end
  end

  def update
    @game = Game.find(params[:id])

    if @game.update_attributes(game_params) && @game.save
      render(json: {type: 'game', action: 'set_time_slot', game: @game, success: true, params: params})
    else
      render(json: {type: 'game', action: 'set_time_slot', game: @game, success: false, params: params})
    end
  end

  private

  def game_params
    params.require(:game).permit(:time_slot_id)
  end
end

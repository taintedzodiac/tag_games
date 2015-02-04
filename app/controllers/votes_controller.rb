class VotesController < ApplicationController
  
  def create
    @vote = Vote.where(game: Game.find(params[:game][:id]), user: current_user).first
    @vote = Vote.create(game: Game.find(params[:game][:id]), user: current_user).with(:game) unless @vote
    
    render(json: {type: 'vote', vote: @vote, total_votes: @vote.game.votes.count, action: 'create', game: @vote.game, success: true})
  end
  
  def destroy
    @vote = Vote.find(params[:id])
    @game = @vote.game
    
    if @vote.destroy()
      render(json: {type: 'vote', vote_id: params[:id], total_votes: @game.votes.count, action: 'destroy', game: @vote.game, success: true})
    else
      render(json: {type: 'vote', vote_id: params[:id], total_votes: @game.votes.count, action: 'destroy', game: @vote.game, success: false})
    end
  end
  
  def post_score
    @vote = Vote.find(params["vote_id"])
    
    if (@vote && current_user == @vote.user)
      @vote.image_id = params[:image_id] if params[:image_id]
      @vote.save
      redirect_to(game_path(@vote.game))
    else
      redirect_to 'root'
    end
  end
end

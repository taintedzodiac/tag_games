class PagesController < ApplicationController

  def home
    @xbox_one_games = Game.where(platform: "Xbox One").asc(:title)
    @ps4_games = Game.where(platform: "PS4").asc(:title)
    @xbox_360_games = Game.where(platform: "Xbox 360").asc(:title)
    @wii_u_games = Game.where(platform: "Wii U").asc(:title)
    @other_games = Game.where(platform: "PC").asc(:title)

    @user_votes = current_user.votes.with(:game) if user_signed_in?
  end
end

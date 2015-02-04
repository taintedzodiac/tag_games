class Vote
  include Mongoid::Document
  
  field :game_title, type: String, default: ''
  field :proof_string, type: String, default: ''
  
  # Score image, when necessary
  field :image_id, type: String, default: nil
  
  belongs_to :game
  belongs_to :user
  
  before_create do
    self.proof_string = [Forgery::Basic.color, Forgery::Address.street_name.split(" ").first, rand(100)].join("-").downcase
  end
  
  before_save do
    self.game_title = self.game.title
  end
end

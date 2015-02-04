class Team
  include Mongoid::Document
  
  field :name,        type: String,     default: ''
  field :logo,        type: String,     default: ''
  
  has_many :members, class_name: 'User', inverse_of: :team # Players on this team
  has_one :captain, class_name: 'User', inverse_of: :captain_team # Each team has a captain
  has_many :assistants, class_name: 'User', inverse_of: :assistant_team # Each team can have assistant captains
  
end

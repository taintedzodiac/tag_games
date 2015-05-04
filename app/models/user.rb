class User
  include Mongoid::Document
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Database authenticatable
  field :username,           :type => String, :default => ""
  field :email,              :type => String, :default => ""
  field :encrypted_password, :type => String, :default => ""

  ## Controls for permissions
  field :admin,              :type => Boolean, :default => false
  field :assistant,          :type => Boolean, :default => false

  ## Used to indicate if this user is currently up to draft a player to their team
  field :drafting,           :type => Boolean, :default => false
  field :draft_order,        :type => Integer, :default => -1
  field :draftable,          :type => Boolean, :default => false

  ## Recoverable
  field :reset_password_token,   :type => String
  field :reset_password_sent_at, :type => Time

  ## Rememberable
  field :remember_created_at, :type => Time

  ## Trackable
  field :sign_in_count,      :type => Integer, :default => 0
  field :current_sign_in_at, :type => Time
  field :last_sign_in_at,    :type => Time
  field :current_sign_in_ip, :type => String
  field :last_sign_in_ip,    :type => String

  ## Require username and to be unique
  validates :username, :presence => true, :uniqueness => true

  ## Confirmable
  # field :confirmation_token,   :type => String
  # field :confirmed_at,         :type => Time
  # field :confirmation_sent_at, :type => Time
  # field :unconfirmed_email,    :type => String # Only if using reconfirmable

  ## Lockable
  # field :failed_attempts, :type => Integer, :default => 0 # Only if lock strategy is :failed_attempts
  # field :unlock_token,    :type => String # Only if unlock strategy is :email or :both
  # field :locked_at,       :type => Time

  has_many :votes, :order => :game_title.asc, dependent: :delete # Vote for which games should be played in the TAG Games
  belongs_to :team, class_name: 'Team', inverse_of: :members # Each player needs to be assigned to a team
  belongs_to :captain_team, class_name: 'Team', inverse_of: :captain # Can be the captain of a team
  belongs_to :assistant_team, class_name: 'Team', inverse_of: :assistants # Can be an assistant captain for a team

  scope :undrafted, ->{ where(team: Team.where(name:"Undrafted").first ) }

  before_create do
    self.team = Team.where(name: "Undrafted").first unless self.team
  end

  # Finds all of the team captains, randomizes the order in which they draft, then sets the first in that order as currently drafting
  def initialize_draft
    captains = User.where(:captain_team.ne => nil).shuffle
    results = ""
    captains.each_with_index do |captain, index|
      captain.draft_order = index
      captain.drafting = (index == 0 ? true : false)
      captain.save
      results += "#{index} #{captain.username} "
    end
    return "Draft Order: #{results}"
  end

  def advance_draft_order
    current_drafter = User.where(drafting: true).first
    next_drafter = User.new
    number_of_captains = User.where(:captain_team.ne => nil).count

    if current_drafter.captain_team.members.count.even? # We're heading up the drafting order
      if current_drafter.draft_order == (number_of_captains - 1) # Highest number drafter, needs to draft another
        return current_drafter
      else # For anyone else, we just go to the next (higher in order) drafter
        next_drafter = User.where(draft_order: current_drafter.draft_order + 1).first
      end
    elsif current_drafter.captain_team.members.count.odd? # We're heading down the drafting order
      if current_drafter.draft_order == 0 # Lowest number drafter, needs to draft another
        return current_drafter
      else
        next_drafter = User.where(draft_order: current_drafter.draft_order - 1).first
      end
    end

    unless next_drafter.new_record?
      current_drafter.drafting = false
      current_drafter.save

      next_drafter.drafting = true
      next_drafter.save
    end

    return next_drafter
  end
end

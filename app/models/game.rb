class Game
  include Mongoid::Document
  
  field :title,       type: String,     default: ''
  field :platform,    type: String,     default: ''
  field :boxart,      type: String,     default: 'http://farm4.staticflickr.com/3720/13107469424_081ffabd6f.jpg'
  field :tag_thread,  type: String,     default: ''
  field :ongoing,     type: Boolean,    default: false
  
  has_many :votes, dependent: :delete # Users can vote on which games should be included
  belongs_to :time_slot
  
  def title_with_platform
    return "#{self.title} (#{self.platform})"
  end
  
  def dummy
    # This is just a dummy method for autocomplete
  end
end

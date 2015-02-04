class TimeSlot
  include Mongoid::Document
  
  field :scheduled_time,        type: DateTime,     default: nil

  has_one :game
end

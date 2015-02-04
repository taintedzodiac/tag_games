class TimeSlotsController < ApplicationController
  
  def index
    @time_slots = TimeSlot.asc(:scheduled_time)
  end
  
end
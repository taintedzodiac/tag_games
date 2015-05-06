class TimeSlotsController < ApplicationController

  def index
    @ongoing_events = Game.ongoing
    @time_slots = TimeSlot.asc(:scheduled_time)
  end

end

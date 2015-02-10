require 'rails_helper'

RSpec.describe Game, type: :model do
  describe 'relations' do
    it { is_expected.to have_many(:votes).of_type(Vote).with_dependent(:delete) }
    it { is_expected.to belong_to(:time_slot).of_type(TimeSlot)}
  end
end

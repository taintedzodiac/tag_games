require 'rails_helper'

RSpec.describe TimeSlot, type: :model do
  describe 'relations' do
    it { is_expected.to have_one(:game).of_type(Game) }
  end
end

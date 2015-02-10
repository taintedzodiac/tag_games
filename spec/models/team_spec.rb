require 'rails_helper'

RSpec.describe Team, type: :model do

  describe 'relations' do
    it { is_expected.to have_many(:members).of_type(User).as_inverse_of(:team) }
    it { is_expected.to have_one(:captain).of_type(User) }
    it { is_expected.to have_many(:assistants).of_type(User).as_inverse_of(:assistant_team) }
  end
end

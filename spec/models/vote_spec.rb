require 'rails_helper'

RSpec.describe Vote, type: :model do
  describe 'relations' do
    it { is_expected.to belong_to(:game).of_type(Game) }
    it { is_expected.to belong_to(:user).of_type(User) }
  end
end

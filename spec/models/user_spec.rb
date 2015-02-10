require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'validations' do
    it { should validate_presence_of(:username) }
    it { should validate_presence_of(:email) }
    it { should validate_presence_of(:password) }
  end

  describe 'relations' do
    it { is_expected.to have_many(:votes).with_foreign_key(:user_id).ordered_by(:game_title) }
    it { is_expected.to belong_to(:team).of_type(Team).as_inverse_of(:members) }
    it { is_expected.to belong_to(:captain_team).of_type(Team).as_inverse_of(:captain) }
    it { is_expected.to belong_to(:assistant_team).of_type(Team).as_inverse_of(:assistants) }
  end
end

require 'rails_helper'

RSpec.describe License, type: :model do
  subject { build(:license) }

  it { is_expected.to validate_presence_of(:key) }
  it { is_expected.to validate_uniqueness_of(:key).case_insensitive }

  it { is_expected.to validate_presence_of(:platform) }
  it { is_expected.to define_enum_for(:platform).with_values({ steam: 0, origin: 1, battle_net: 2 }) }
  
  it { is_expected.to validate_presence_of(:status) }
  it { is_expected.to define_enum_for(:status).with_values({ active: 0, used: 1 , inactive: 2 }) }
 
  it { is_expected.to belong_to(:game) }
end

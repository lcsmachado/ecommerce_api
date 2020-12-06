class License < ApplicationRecord
  include Paginatable

  belongs_to :game

  validates :key, presence: true, uniqueness: { case_sensitive: false, scope: :platform }
  validates :platform, presence: true
  validates :status, presence: true

  enum platform: { steam: 0, origin: 1, battle_net: 2 }
  enum status: { active: 0, used: 1, inactive: 2 }
end

FactoryBot.define do
  factory :license do
    key { Faker::Crypto.md5 }
    platform { %i[steam origin battle_net].sample }
    status { %i[active used inactive].sample }
    game
  end
end

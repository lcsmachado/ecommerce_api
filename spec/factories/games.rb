FactoryBot.define do
  factory :game do
    mode { %i[pvp pve both].sample }
    release_date { '2020-11-07 17:01:52' }
    developer { Fake::Company.name }
    system_requirement
  end
end

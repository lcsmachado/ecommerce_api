FactoryBot.define do
  factory :system_requirement do
    sequence(:name) { |n| "Basic #{n}" }
    operational_system { Faker::Computer.os }
    storage { "50GB" }
    processor { "AMD Ryzen 7x" }
    memory { "4GB" }
    video_board { "GeForce GTX3082" }
  end
end

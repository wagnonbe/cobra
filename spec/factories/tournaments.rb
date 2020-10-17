FactoryGirl.define do
  factory :tournament do
    name 'Tournament Name'
    single_sided_swiss false
    user

    trait :single_sided do
      single_sided_swiss true
    end

    transient do
      player_count 0
    end

    after(:create) do |tournament, evaluator|
      create_list(:player, evaluator.player_count, tournament: tournament)
    end
  end
end

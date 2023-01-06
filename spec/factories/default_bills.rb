# frozen_string_literal: true

FactoryBot.define do
  factory :default_bill do
    bill_name = Faker::Game.unique.title

    name { bill_name }
    value_in_cents { rand(100..1000) }
    slug { "#{bill_name}-#{SecureRandom.hex(3)}".downcase.parameterize }

    association :user
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :default_bill do
    bill_name = Faker::Game.unique.title

    name { bill_name }
    slug { Faker::Internet.slug(words: "#{bill_name} #{SecureRandom.hex(3)}") }
    value_in_cents { rand(100..1000) }

    association :user
  end
end

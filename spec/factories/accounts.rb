# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    bill_name = Faker::Game.unique.title

    name { bill_name }
    slug { Faker::Internet.slug(words: "#{bill_name} #{SecureRandom.hex(3)}") }

    association :user
  end
end

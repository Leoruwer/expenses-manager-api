# frozen_string_literal: true

FactoryBot.define do
  factory :account do
    account_name = Faker::Game.unique.title

    name { account_name }
    slug { Faker::Internet.slug(words: "#{account_name} #{SecureRandom.hex(3)}") }

    association :user
  end
end

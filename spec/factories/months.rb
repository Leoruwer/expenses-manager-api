# frozen_string_literal: true

FactoryBot.define do
  factory :month do
    month_name = Faker::Game.unique.title

    name { month_name }
    slug { Faker::Internet.slug(words: "#{month_name} #{SecureRandom.hex(3)}") }

    association :user
  end
end

# frozen_string_literal: true

FactoryBot.define do
  factory :year do
    year_name = Faker::Game.unique.title

    name { year_name }
    slug { Faker::Internet.slug(words: "#{year_name} #{SecureRandom.hex(3)}") }

    association :user
  end
end

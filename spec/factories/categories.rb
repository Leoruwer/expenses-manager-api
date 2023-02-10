# frozen_string_literal: true

FactoryBot.define do
  factory :category do
    category_name = Faker::Game.unique.title

    name { category_name }
    slug { Faker::Internet.slug(words: "#{category_name} #{SecureRandom.hex(3)}") }

    association :user
  end
end

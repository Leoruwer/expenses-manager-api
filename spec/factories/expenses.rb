# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    expense_name = Faker::Game.unique.title

    name { expense_name }
    slug { Faker::Internet.slug(words: "#{expense_name} #{SecureRandom.hex(3)}") }
    value_in_cents { rand(100..1000) }
    due_at { Time.parse('21-06-2022') }
    paid_at { Time.parse('28-04-2022') }

    association :user
    association :account
    association :category
  end
end

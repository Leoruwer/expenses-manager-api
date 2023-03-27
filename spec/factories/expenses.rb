# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    expense_name = Faker::Game.unique.title

    name { expense_name }
    slug { Faker::Internet.slug(words: "#{expense_name} #{SecureRandom.hex(3)}") }
    value_in_cents { rand(100..1000) }
    due_at { DateTime.parse('2022-06-21 15:30:00') }
    paid_at { DateTime.parse('2022-04-28 10:00:00') }

    association :user
    association :account
    association :category
  end
end

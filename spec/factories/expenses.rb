# frozen_string_literal: true

FactoryBot.define do
  factory :expense do
    expense_name = Faker::Game.unique.title

    name { expense_name }
    slug { Faker::Internet.slug(words: "#{expense_name} #{SecureRandom.hex(3)}") }
    value_in_cents { rand(100..1000) }
    due_at { '2022-06-21T03:00:00.000Z' }
    paid_at { '2022-04-28T03:00:00.000Z' }

    association :user
    association :account
    association :category
  end
end

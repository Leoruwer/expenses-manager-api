# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    user_name = Faker::Name.unique.name

    name { user_name }
    slug { Faker::Internet.slug(words: "#{user_name} #{SecureRandom.hex(3)}") }
    email { Faker::Internet.email(name: user_name, separators: '.') }
    password { Faker::Internet.password }
  end
end

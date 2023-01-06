# frozen_string_literal: true

FactoryBot.define do
  factory :user do
    user_name = Faker::Name.unique.name

    name { user_name }
    slug { "#{user_name}-#{SecureRandom.hex(3)}".downcase.parameterize }
    email { Faker::Internet.email(name: user_name, separators: '.') }
    password { Faker::Internet.password }
  end
end

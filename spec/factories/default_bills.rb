# frozen_string_literal: true

FactoryBot.define do
  factory :default_bill do
    name { 'Default Bill' }
    value_in_cents { 100 }
    slug { 'default_bill-1' }
  end
end

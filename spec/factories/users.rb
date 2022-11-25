FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    slug { "john-doe-1" }
    email { 'john.doe@mail.com' }
    password { 'securePassword123' }
  end
end

FactoryBot.define do
  factory :user do
    name { 'John Doe' }
    username { 'Johnd' }
    email { 'john.doe@mail.com' }
    password { 'securePassword123' }
  end
end

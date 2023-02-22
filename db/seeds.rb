# frozen_string_literal: true

default_admin = User.create(name: 'Admin User', email: 'admin@admin.com', password: 'admin123', role: :admin)
default_user = User.create(name: 'Normal User', email: 'user@user.com', password: 'user123')

5.times do
  Account.create(name: Faker::Game.unique.title, user: default_admin)
  DefaultBill.create(name: Faker::Game.unique.title, value_in_cents: rand(100..1000), user: default_admin)
  Category.create(name: Faker::Game.unique.title, user: default_admin)
  Expense.create(
    name: Faker::Game.unique.title,
    value_in_cents: rand(100..1000),
    account: default_admin.accounts.first,
    category: default_admin.categories.first,
    user: default_admin
  )

  Account.create(name: Faker::Game.unique.title, user: default_user)
  DefaultBill.create(name: Faker::Game.unique.title, value_in_cents: rand(100..1000), user: default_user)
  Category.create(name: Faker::Game.unique.title, user: default_user)
  Expense.create(
    name: Faker::Game.unique.title,
    value_in_cents: rand(100..1000),
    account: default_user.accounts.first,
    category: default_user.categories.first,
    user: default_user
  )
end

# frozen_string_literal: true

class Expense < ApplicationRecord
  after_initialize :slugify_name

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :slug, uniqueness: { scope: :user }
  validates :value_in_cents, presence: true
  validates :due_at, presence: true

  monetize :value_in_cents

  belongs_to :user
  belongs_to :account
  belongs_to :category

  scope :by_year, ->(year) { where('extract(year from due_at) = ?', year) }
  scope :by_month, ->(month) { where('extract(month from due_at) = ?', month) }
  scope :by_due, lambda { |year, month|
                   where('extract(year from due_at) = ? AND extract(month from due_at) = ?', year, month)
                 }

  store :account
  store :category

  private

  def slugify_name
    slugify(name)
  end
end

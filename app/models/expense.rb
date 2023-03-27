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

  private

  def slugify_name
    slugify(name)
  end
end

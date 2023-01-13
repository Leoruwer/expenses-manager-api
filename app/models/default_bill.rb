# frozen_string_literal: true

class DefaultBill < ApplicationRecord
  after_initialize :slugify_name

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :slug, uniqueness: { scope: :user }

  monetize :value_in_cents

  belongs_to :user

  private

  def slugify_name
    slugify(name)
  end
end

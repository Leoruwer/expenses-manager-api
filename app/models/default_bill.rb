# frozen_string_literal: true

class DefaultBill < ApplicationRecord
  after_initialize :slugify_name

  validates :name, presence: true
  validates :slug, uniqueness: true

  belongs_to :user

  private

  def slugify_name
    slugify(name)
  end
end

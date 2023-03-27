# frozen_string_literal: true

class Category < ApplicationRecord
  after_initialize :slugify_name

  validates :name, presence: true, uniqueness: { scope: :user }
  validates :slug, uniqueness: { scope: :user }

  belongs_to :user

  has_many :expenses, dependent: :destroy

  private

  def slugify_name
    slugify(name)
  end
end

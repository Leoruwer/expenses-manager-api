# frozen_string_literal: true

class Year < ApplicationRecord
  after_initialize :slugify_user

  validates :name, presence: true
  validates :slug, uniqueness: true

  belongs_to :user

  private

  def slugify_user
    self.slug = "#{name}-#{SecureRandom.hex(3)}".downcase.parameterize
  end
end

# frozen_string_literal: true

class Account < ApplicationRecord
  after_initialize :slugify_user

  validates :name, presence: true
  validates :slug, uniqueness: true

  private

  def slugify_user
    self.slug = "#{name}-#{SecureRandom.hex(3)}".downcase.parameterize
  end
end

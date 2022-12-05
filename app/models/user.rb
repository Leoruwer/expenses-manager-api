# frozen_string_literal: true

class User < ApplicationRecord
  after_initialize :slugify_user

  has_secure_password
  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :slug, uniqueness: true
  validates :name, presence: true

  validates :password,
            length: { minimum: 6 },
            if: -> { new_record? || !password.nil? }

  enum :role, %i[
    user
    admin
  ]

  has_many :default_bills, dependent: :destroy

  private

  def slugify_user
    self.slug = "#{name}-#{SecureRandom.hex(3)}".downcase.parameterize
  end
end

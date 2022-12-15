# frozen_string_literal: true

class DefaultBill < ApplicationRecord
  validates :name, presence: true
  validates :slug, uniqueness: true

  belongs_to :user
end

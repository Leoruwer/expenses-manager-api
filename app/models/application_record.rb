# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  primary_abstract_class

  protected

  def slugify(value)
    self.slug = "#{value}-#{SecureRandom.hex(3)}".downcase.parameterize if value.present?
  end
end

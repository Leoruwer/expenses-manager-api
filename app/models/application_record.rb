# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  after_initialize :slugify_name

  primary_abstract_class

  protected

  def slugify_name
    self.slug = "#{name}-#{SecureRandom.hex(3)}".downcase.parameterize if name.present?
  end
end

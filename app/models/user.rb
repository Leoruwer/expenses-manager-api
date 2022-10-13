class User < ApplicationRecord
  enum :role, [
    :user,
    :admin
  ]
end

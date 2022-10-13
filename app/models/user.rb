class User < ApplicationRecord
  enum :user_type, [
    :user,
    :admin
  ]
end

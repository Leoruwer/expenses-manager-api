class SlugifyUser
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def execute
    user.update(
      slug: "#{user.name.parameterize}-#{user.id}"
    )

    user
  end
end

class CreateUser
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def execute
    user = User.create!(params)
    user.update(
      slug: "#{user.name.parameterize}-#{user.id}"
    )

    user
  end
end

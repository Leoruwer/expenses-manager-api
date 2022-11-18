class CreateUser
  attr_reader :params

  def initialize(params)
    @params = params
  end

  def execute
    formatted_params = params.merge({ slug: "#{params[:name]&.parameterize}-#{params[:id]}" })

    User.create(formatted_params)
  end
end

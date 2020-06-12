class ApplicationController < ActionController::API

  rescue_from ActionController::ParameterMissing, with: :parameter_missing

  protected

  def parameter_missing(ex)
    render status: 400, json: {errors: [
      {name: :parameter_missing, message: ex.message}
    ]}
  end
end

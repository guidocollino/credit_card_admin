class AgenciesController < ApplicationController
  def index
    render json: AeroAPI::Agency.find(:all, params: {criteria: params[:q]})
  end

  def show
    render json: AeroAPI::Agency.find(params[:id])
  end

end

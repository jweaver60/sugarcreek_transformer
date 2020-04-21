class UploadsController < ApplicationController

  def index
  end

  def upload
    if params[:csv].blank?
      redirect_to root_path, alert: "Please upload a valid CSV file."
    elsif File.extname(params[:csv].original_filename) != ".csv"
      redirect_to root_path, alert: "File is not a CSV."
    else
      @data = OrderTransformService.new(params[:csv]).transform
      send_data @data, filename: "TRANSFORMED_#{params[:csv].original_filename}", disposition: :attachment
    end
  end

end
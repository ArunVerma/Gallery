class ArtGalleriesController < ApplicationController
  def index
  end

  def log_visitor_records
    file = params[:file].present? ? params[:file].tempfile : nil
    content_type = params[:file].present? ? params[:file].content_type : nil
    @gallery = ArtGallery.new(file, content_type)
    @results = nil
    if @gallery.valid?
      @results = @gallery.collect_data
    end
  end
end

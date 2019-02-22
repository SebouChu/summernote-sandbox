class UploadsController < ApplicationController
  skip_before_action :verify_authenticity_token

  def create
    io = params[:file].to_io
    filename = params[:file].original_filename
    content_type = params[:file].content_type
    blob = ActiveStorage::Blob.create_after_upload! io: io, filename: filename, content_type: content_type
    blob.analyze
    blob_url = url_for blob
    image_component = view_context.render(partial: 'components/image', locals: { image: blob })
    render json: { id: blob.id, url: blob_url, node: image_component }
  end
end
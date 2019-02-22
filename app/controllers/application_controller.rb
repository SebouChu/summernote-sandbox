class ApplicationController < ActionController::Base

  def test
    image_blob = ActiveStorage::Blob.first

    render partial: 'components/image', locals: { image: image_blob }
  end

end

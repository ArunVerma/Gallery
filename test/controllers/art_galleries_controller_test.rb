require 'test_helper'

class ArtGalleriesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get art_galleries_index_url
    assert_response :success
  end

end

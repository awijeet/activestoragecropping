require 'test_helper'

class AjaxControllerTest < ActionDispatch::IntegrationTest
  test "should get cropper" do
    get ajax_cropper_url
    assert_response :success
  end

end

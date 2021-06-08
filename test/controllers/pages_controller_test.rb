require "test_helper"

class PagesControllerTest < ActionDispatch::IntegrationTest
  test "should get admin" do
    get pages_admin_url
    assert_response :success
  end

  test "should get about" do
    get pages_about_url
    assert_response :success
  end
end

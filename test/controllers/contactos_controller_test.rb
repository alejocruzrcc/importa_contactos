require "test_helper"

class ContactosControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get contactos_index_url
    assert_response :success
  end
end

require 'test_helper'

class AccountActivationsControllerTest < ActionDispatch::IntegrationTest
  test "should get create" do
    get account_activations_create_url
    assert_response :success
  end

  test "should get edit" do
    get account_activations_edit_url
    assert_response :success
  end

end

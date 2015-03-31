require 'test_helper'

class Api::V1::AdminCreditCardsControllerTest < ActionController::TestCase
  test "should get to_use_credit_cards" do
    get :to_use_credit_cards
    assert_response :success
  end

  test "should get use_credit_card" do
    get :use_credit_card
    assert_response :success
  end

  test "should get cancel_use" do
    get :cancel_use
    assert_response :success
  end

end

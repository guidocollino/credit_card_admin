require 'test_helper'

class ToUseCreditCardsControllerTest < ActionController::TestCase
  setup do
    @to_use_credit_card = to_use_credit_cards(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:to_use_credit_cards)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create to_use_credit_card" do
    assert_difference('ToUseCreditCard.count') do
      post :create, to_use_credit_card: { amount: @to_use_credit_card.amount, blocked: @to_use_credit_card.blocked, expiration_month: @to_use_credit_card.expiration_month, expiration_year: @to_use_credit_card.expiration_year, holder: @to_use_credit_card.holder, load_file: @to_use_credit_card.load_file, number: @to_use_credit_card.number, security_code: @to_use_credit_card.security_code }
    end

    assert_redirected_to to_use_credit_card_path(assigns(:to_use_credit_card))
  end

  test "should show to_use_credit_card" do
    get :show, id: @to_use_credit_card
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @to_use_credit_card
    assert_response :success
  end

  test "should update to_use_credit_card" do
    patch :update, id: @to_use_credit_card, to_use_credit_card: { amount: @to_use_credit_card.amount, blocked: @to_use_credit_card.blocked, expiration_month: @to_use_credit_card.expiration_month, expiration_year: @to_use_credit_card.expiration_year, holder: @to_use_credit_card.holder, load_file: @to_use_credit_card.load_file, number: @to_use_credit_card.number, security_code: @to_use_credit_card.security_code }
    assert_redirected_to to_use_credit_card_path(assigns(:to_use_credit_card))
  end

  test "should destroy to_use_credit_card" do
    assert_difference('ToUseCreditCard.count', -1) do
      delete :destroy, id: @to_use_credit_card
    end

    assert_redirected_to to_use_credit_cards_path
  end
end

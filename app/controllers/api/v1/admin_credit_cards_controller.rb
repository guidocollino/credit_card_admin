class Api::V1::AdminCreditCardsController < ApplicationController
  skip_before_filter :cas_filter, :current_user
  skip_before_filter  :verify_authenticity_token

  def to_use_credit_cards
  	@credit_cards = ToUseCreditCard.to_use.only(:id, :expiration_month, :expiration_year, :amount, :bank_id, 
      :credit_card_id, :quotes, :agency_id, :reason_id, :use_datas, :date_limit, :clarification)
  	@credit_cards = @credit_cards.sort_by! { |card| [card.reason.priority , card.expiration_year,  card.expiration_month, card.cant_use_amount] }
  end

  def use_credit_card
  	user = User.new(nil, params[:user_id],  params[:user_name], nil, nil)
  	to_use_credit_card = ToUseCreditCard.find(params[:credit_card_id])
  	if to_use_credit_card.valid_use(params[:used_file], params[:amount])
      to_use_credit_card.use(params[:amount], user, params[:es_sale_id], params[:used_file])
      card_to_use = to_use_credit_card.to_json(
      	:include => { 
      		:bank => { :only => :name }, 
      		:credit_card => { :only => :name } 
      		})
      render json: { :card => ActiveSupport::JSON.decode(card_to_use), :use_amount =>  params[:amount]}, status: :ok
    else
      render json: {:errors => to_use_credit_card.errors.full_messages.join(" / ") }, status: '403'
    end
  end

  def cancel_use
  end

end

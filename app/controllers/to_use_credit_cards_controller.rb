class ToUseCreditCardsController < ApplicationController
  before_action :set_to_use_credit_card, only: [:show, :edit, :update, :destroy]

  # GET /to_use_credit_cards
  # GET /to_use_credit_cards.json
  def index
    @to_use_credit_cards = ToUseCreditCard.all
  end

  # GET /to_use_credit_cards/1
  # GET /to_use_credit_cards/1.json
  def show
  end

  # GET /to_use_credit_cards/new
  def new
    @to_use_credit_card = ToUseCreditCard.new
  end

  # GET /to_use_credit_cards/1/edit
  def edit
  end

  # POST /to_use_credit_cards
  # POST /to_use_credit_cards.json
  def create
    @to_use_credit_card = ToUseCreditCard.new(to_use_credit_card_params)

    respond_to do |format|
      if @to_use_credit_card.save
        format.html { redirect_to @to_use_credit_card, notice: 'To use credit card was successfully created.' }
        format.json { render :show, status: :created, location: @to_use_credit_card }
      else
        format.html { render :new }
        format.json { render json: @to_use_credit_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /to_use_credit_cards/1
  # PATCH/PUT /to_use_credit_cards/1.json
  def update
    respond_to do |format|
      if @to_use_credit_card.update(to_use_credit_card_params)
        format.html { redirect_to @to_use_credit_card, notice: 'To use credit card was successfully updated.' }
        format.json { render :show, status: :ok, location: @to_use_credit_card }
      else
        format.html { render :edit }
        format.json { render json: @to_use_credit_card.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /to_use_credit_cards/1
  # DELETE /to_use_credit_cards/1.json
  def destroy
    @to_use_credit_card.destroy
    respond_to do |format|
      format.html { redirect_to to_use_credit_cards_url, notice: 'To use credit card was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_to_use_credit_card
      @to_use_credit_card = ToUseCreditCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def to_use_credit_card_params
      params.require(:to_use_credit_card).permit(:number, :expiration_month, :expiration_year, :security_code, :holder, :amount, :load_file, :blocked)
    end
end

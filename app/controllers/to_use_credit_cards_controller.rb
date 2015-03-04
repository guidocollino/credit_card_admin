class ToUseCreditCardsController < ApplicationController
  before_action :set_to_use_credit_card, only: [:show, :edit, :update, :destroy, :use_credit_card, :take_credit_card, 
                                                :free_credit_card, :use_form, :reuse_credit_card, :disable_credit_card,
                                                :enable_credit_card]
  before_action :set_banks_credit_cards_reasons, only: [:new, :edit]

  # GET /to_use_credit_cards
  # GET /to_use_credit_cards.json
  def index
    @credit_cards = ToUseCreditCard.to_use.only(:id, :expiration_month, :expiration_year, :amount, :bank_id, 
      :credit_card_id, :quotes, :agency_id, :reason_id, :use_datas, :date_limit)
    #@credit_cards = ToUseCreditCard.to_use
    @credit_cards = @credit_cards.sort_by! { |card| [card.reason.priority , card.expiration_year,  card.expiration_month, card.cant_use_amount] }
    @table_name = "to_use"
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
    @to_use_credit_card.creator_id = current_user.id
    @to_use_credit_card.creator_name = current_user.name_and_surname
    respond_to do |format|
      if @to_use_credit_card.save
        format.html { redirect_to to_use_credit_cards_url, notice: 'La tarjeta fue creada con éxito.' }
        format.json { render :show, status: :created, location: @to_use_credit_card }
      else
        set_banks_credit_cards_reasons
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
        format.html { redirect_to to_use_credit_cards_url, notice: 'La tarjeta fue actualizada con éxito.' }
        format.json { render :show, status: :ok, location: @to_use_credit_card }
      else
        set_banks_credit_cards_reasons
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
      format.html { redirect_to to_use_credit_cards_url, notice: 'La tarjeta fue borrada con éxito.' }
      format.json { head :no_content }
    end
  end

  def take_credit_card
    respond_to do |format|
      if @to_use_credit_card.blocked?
        format.html { redirect_to to_use_credit_cards_url, alert: 'La tarjeta ya fue tomada' }
        format.json { head :no_content }
      else
        @to_use_credit_card.take(current_user)
        format.html { redirect_to taked_credit_cards_to_use_credit_cards_path, notice: 'La tarjeta se tomo para ser usada con éxito'  }
        format.json { render :show, status: :ok, location: @to_use_credit_card }
      end
    end
  end

  def free_credit_card
    respond_to do |format|
      if @to_use_credit_card.blocked?
        @to_use_credit_card.free
        format.html { redirect_to to_use_credit_cards_url, notice: 'La tarjeta liberó con éxito'  }
        format.json { render :show, status: :ok, location: @to_use_credit_card }
      else
        format.html { redirect_to taked_credit_cards_to_use_credit_cards_path alert: 'La tarjeta NO esta tomada' }
        format.json { head :no_content }
      end
    end
  end

  def use_credit_card
    respond_to do |format|
      if @to_use_credit_card.blocked?
        if @to_use_credit_card.valid_use(params[:used_file], params[:amount])
          @to_use_credit_card.use(params[:used_file], params[:amount], current_user)
          format.html { redirect_to used_credit_cards_to_use_credit_cards_path, notice: 'La tarjeta se uso con éxito'  }
          format.json { render :show, status: :ok, location: @to_use_credit_card }
          format.js   { 
            flash[:notice] = "La tarjeta se uso con éxito" 
            render js: "$('#myModal').modal('hide');window.location = '/to_use_credit_cards/taked_credit_cards';"
            #render js: "$('#myModal').modal('hide');"
            
          }
        else
          format.json { render :json => { :errors => @to_use_credit_card.errors }, :status => 409 }
          format.js   { render js: "alert('Se encontraron los siguientes errores #{@to_use_credit_card.print_errors}');"}
        end
      else
        format.html { redirect_to @to_use_credit_card, alert: 'La tarjeta NO esta tomada' }
        format.json { head :no_content }
      end
    end
  end

  def reuse_credit_card
    respond_to do |format|
      if @to_use_credit_card.reuse(params[:data_use_id])
        @to_use_credit_card.take(current_user)
        format.html { redirect_to taked_credit_cards_to_use_credit_cards_path, notice: 'Quedo habilitado el monto que se marco para reusar'  }
        format.json { render :show, status: :ok, location: @to_use_credit_card }
      else
        format.html { redirect_to taked_credit_cards_to_use_credit_cards_path, alert: 'El monto ya se reuso' }
        format.json { head :no_content }
      end
    end
  end

  def disable_credit_card
    respond_to do |format|
        @to_use_credit_card.disable
        @to_use_credit_card.take(current_user)
        format.html { redirect_to disabled_credit_cards_to_use_credit_cards_path, notice: 'La tarjeta quedo deshabilitada'  }
        format.json { render :show, status: :ok, location: @to_use_credit_card }
    end
  end

  def enable_credit_card
    respond_to do |format|
      if @to_use_credit_card.disabled?
        @to_use_credit_card.enable(current_user)
        format.html { redirect_to taked_credit_cards_to_use_credit_cards_path, notice: 'La tarjeta quedo en tomadas para se usada nuevamente'  }
        format.json { render :show, status: :ok, location: @to_use_credit_card }
      else
        format.html { redirect_to @to_use_credit_card, notice: 'La tarjeta NO deshabilitada' }
        format.json { head :no_content }
      end
    end
  end

  #####################################################

  def taked_credit_cards
    @credit_cards = ToUseCreditCard.takeds(current_user.id)
    @table_name = "taked"
    render :index
  end

  def used_credit_cards
    @uses = ToUseCreditCard.all_uses
    @table_name = "used"
    render :index
  end

  def disabled_credit_cards
    @credit_cards = ToUseCreditCard.disableds
    @table_name = "disabled"
    render :index
  end

  ######################################################

  def use_form
    render :layout => false
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_to_use_credit_card
      @to_use_credit_card = ToUseCreditCard.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def to_use_credit_card_params
      params.require(:to_use_credit_card).permit(:number, :expiration_month, :expiration_year, 
        :security_code, :holder, :amount, :load_file, :blocked, :bank_id, :credit_card_id, :quotes, :agency_id,
        :reason_id, :date_limit, :allows_partial_use)
    end

    def set_banks_credit_cards_reasons
      @banks = Bank.all.map { |bank| [bank.name, bank.id] }
      @credit_cards = CreditCard.all.map { |credit_card| [credit_card.name, credit_card.id] }
      @reasons = ReasonOfUse.all.map { |reason| [reason.name, reason.id] }
    end
end

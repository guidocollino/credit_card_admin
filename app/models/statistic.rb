class Statistic
  attr_accessor :collection
  
  #Statistics of cards available to use
  
  def initialize
    @collection={}
  end

  def agency_exist?(agency)
    @collection.has_key?(agency)
  end

  def add_agency_not_used(agency, amount)
    if agency_exist?(agency)
      @collection[agency]={"agency" => agency, "amount" => @collection[agency]['amount'] + amount, "total_cards_agency" => @collection[agency]['total_cards_agency'] + 1 }
    else
      @collection[agency]={"agency" => agency, "amount" => amount, "total_cards_agency" => 1 }  
    end  
  end

  def amount_pending
    amount=0
    @collection.each_value{|agency| amount+= agency['amount']}
    amount
  end

  def total_cards
    cards=0
    @collection.each_value{|agency| cards+= agency['total_cards_agency']}
    cards
  end

end

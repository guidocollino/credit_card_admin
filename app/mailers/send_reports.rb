class SendReports < ActionMailer::Base
  default from: "aerolaplata.web@gmail.com"

  def report_cards_for_use(user_email)
    useCreditCards=ToUseCreditCard.where(used: :false) 
    @reports=Statistic.new
    useCreditCards.each do |obj|
      @reports.add_agency_not_used(obj.agency_name, obj.cant_use_amount)
    end 
    # file=CSV.new
    # @reports.collection.each_value do | agency |
    #   file << agency
    # end
    # attachments['file.csv'] = file
    mail(to: user_email, subject: "Reporte de tarjetas para usar")
  end

end
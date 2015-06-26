class SendReports < ActionMailer::Base
  default from: "aerolaplata.web@gmail.com"

  def report_cards_for_use(user_email)
    @reports = ToUseCreditCard.report_credit_card_to_use
    mail(to: user_email, subject: "Reporte de tarjetas para usar")
  end

  def report_cards_expire(user_email)
    @reports = ToUseCreditCard.report_credit_card_expiration
    mail(to: user_email, subject: "Reporte de tarjetas a vencer")
  end

end
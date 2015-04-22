class NotificationUses < ActionMailer::Base
  default from: "aerolaplata.web@gmail.com"

  def notify_use(use_data)
    @use = use_data
    @credit_card = use_data.to_use_credit_card
    mail(to: @credit_card.email, subject: "Se uso la TC de #{@credit_card.holder} por #{@use.descriptive_amount} / Agencia: #{@credit_card.agency_name}")
  end
end

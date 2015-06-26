class SendReportsCardsExpireJob
  @queue = :reports_card_expire_emails_queue

  def self.perform(user)
    SendReports.report_cards_expire(user).deliver
  end

end
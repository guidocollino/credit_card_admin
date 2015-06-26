class SendReportsJob
  @queue = :reports_cards_use_emails_queue

  def self.perform(user)
    SendReports.report_cards_for_use(user).deliver
  end

end
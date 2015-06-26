namespace :send_email do
  task :report => :environment do
    Resque.enqueue(SendReportsJob , 'estebans991@gmail.com')
  end

  task :report_cards_expiration => :environment do
    Resque.enqueue(SendReportsCardsExpireJob , 'estebans991@gmail.com')
  end
end
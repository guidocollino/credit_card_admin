namespace :send_email do
  task :report => :environment do
    Resque.enqueue(SendReportsJob , 'estebans991@gmail.com')
  end
end
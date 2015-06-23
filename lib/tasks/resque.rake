require 'resque/tasks'

task 'resque:setup' => :environment 
# require "rubygems"
# require "rufus/scheduler"

# scheduler = Rufus::Scheduler.new
# # scheduler.in '10d' do
# #   # do something in 10 days
# # end
# scheduler.every '30s' do

#    Resque.enqueue(SendReportsJob , 'estebans991@gmail.com')
# end


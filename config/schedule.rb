# Use this file to easily define all of your cron jobs.

set :output, File.join(File.expand_path(File.dirname(__FILE__)),"..", "log", "cron_log.log")

job_type :rake,         "cd :path && RAILS_ENV=:environment bundle exec rake :task :output"

# Fetch pages from S-BAHN and BVG every 30 minutes
every 30.minutes do
  rake "fetcher:berlin", :environment => :production
end

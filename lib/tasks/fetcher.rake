namespace :fetcher do

  desc 'Fetch lift info from s-bahn and bvg'
  task :berlin => :environment do
    now   = Time.now.to_i
    file  = "#{now}.html"
    FileUtils.mkdir_p( Rails.root.join('public', 'system', 'SBAHN'))
    FileUtils.mkdir_p( Rails.root.join('public', 'system', 'BVG'  ))
    system "wget -q http://www.s-bahn-berlin.de/fahrplanundnetz/mobilitaetsstoerungen.php -O #{Rails.root.join('public', 'system', 'SBAHN', file)}"
    system "wget -q http://www.bvg.de/index.php/de/9466/name/Aufzugsmeldungen.html -O #{Rails.root.join('public', 'system', 'BVG', file)}"

    Delayed::Job.enqueue(SbahnParserJob.new(now))
  end

  desc 'Reprocess fetched files'
  task :reprocess => :environment do
    times = []
    Dir[Rails.root.join('public', 'system', 'SBAHN', '*.html')].each do |file|
      puts "Reschedule: #{file}"
      time = File.basename(file, '.html')
      times << time.to_i
    end

    times.sort.each do |time|
      Delayed::Job.enqueue(SbahnParserJob.new(time))
    end
  end
end
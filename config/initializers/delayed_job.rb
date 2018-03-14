Delayed::Worker.logger = Logger.new(File.join(Rails.root, 'log', 'delayed_job.log'))
Delayed::Worker.sleep_delay = 10 #seconds

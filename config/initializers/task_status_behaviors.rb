Dir[File.join(Rails.root, 'lib/task_status_behaviors/*_behavior.rb')].each { |f| require f }
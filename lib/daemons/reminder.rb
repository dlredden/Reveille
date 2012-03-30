#!/usr/bin/env ruby

# You might want to change this
#ENV["RAILS_ENV"] ||= "production"

require File.dirname(__FILE__) + "/../../config/environment"

$running = true
Signal.trap("TERM") do 
  $running = false
end

while($running) do
  # Get the next users to process
  @users_to_process = AccountUser.next_for_reminders()
  
  if (@users_to_process.length > 0)
    # Grab the starting time
    @start = Time.now
    
    @users_to_process.each { |account_user|
      Rails.logger.info "Processing account '#{account_user.account.backpack_sitename}' for user '#{account_user.user.full_name}'"
      account_user.process_my_backpack_reminders()
    }
    
    # Log the number of users processed and how long it took 
    Rails.logger.info "Reminder Daemon: Processed #{@users_to_process.length} user accounts in #{Time.now - @start} seconds"
  else
    Rails.logger.info "Reminder Daemon: Sleeping for #{SLEEP_TIME} seconds"
    sleep SLEEP_TIME
  end
end
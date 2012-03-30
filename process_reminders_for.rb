#!/usr/bin/env ruby

# You might want to change this
#ENV["RAILS_ENV"] ||= "production"

require "./config/environment"

# Get the next users to process
@users_to_process = AccountUser.next_for_reminders()
p "Processing #{@users_to_process.length} user accounts"
if (@users_to_process.length > 0)
  # Grab the starting time
  @start = Time.now
    
  @users_to_process.each { |account_user|
    p "Processing account '#{account_user.account.backpack_sitename}' for user '#{account_user.user.full_name}'"
    account_user.process_my_backpack_reminders()
  }
    
  # Log the number of users processed and how long it took 
  p "Processed #{@users_to_process.length} user accounts in #{Time.now - @start} seconds"
else
  "No Reminders to process"
end

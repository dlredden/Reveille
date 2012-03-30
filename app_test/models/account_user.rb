require 'ruby_wrapper'
require 'backpack_calendar'

class AccountUser < ActiveRecord::Base
  belongs_to :account
  has_many :backpack_reminders, :dependent => :destroy
  belongs_to :user, :dependent => :destroy
  
  def is_admin()
    (self.role == "Admin") ? true : false
  end
  
  def calendars()
    @retry = true
    
    begin
      @calendarapi = calendar_connection()
      @calendarapi.calendars
    rescue Exception => ex
      logger.info ex
      switch_ssl()
      if (@retry)
        @retry = false
        retry
      else
        logger.info "Both SSL and non-SSL connections to Backpack have failed for #{self.account.backpack_sitename}"
        return false
      end
    end
  end
  
  def calendar_events(calendar_id)
    @retry = true
    
    begin
      @calendarapi = calendar_connection()
      @calendarapi.calendar_events(calendar_id)
    rescue Exception => ex
      logger.info ex
      switch_ssl()
      if (@retry)
        @retry = false
        retry
      else
        logger.info "Both SSL and non-SSL connections to Backpack have failed for #{self.account.backpack_sitename}"
        return false
      end
    end
  end
  
  def calendar_event(calendar_event_id)
    @retry = true
    
    begin
      @calendarapi = calendar_connection()
      @calendarapi.calendar_event(calendar_event_id)
    rescue Exception => ex
      logger.info ex
      switch_ssl()
      if (@retry)
        @retry = false
        retry
      else
        logger.info "Both SSL and non-SSL connections to Backpack have failed for #{self.account.backpack_sitename}"
        return false
      end
    end
  end
  
  def reminders()
    @reminders = []
    @retry = true
    
    begin
      @backpackapi = backpack_connection()
      @my_reminders = @backpackapi.list_reminders()["reminder"]
    rescue Exception => ex
      logger.info ex
      switch_ssl()
      if (@retry)
        @retry = false
        retry
      else
        logger.info "Both SSL and non-SSL connections to Backpack have failed for #{self.account.backpack_sitename}"
        return false
      end
    end

    if (@my_reminders != nil)
      @my_reminders.each { |reminder|
        @reminders.push(Reminder.new(reminder))
      }
    end
    
    @reminders
  end
  
  def process_my_backpack_reminders()
    @retry = true
    @calendar_event_ids = []
    initialize_regex()
    @reminder_pattern = Regexp.new(/\#rem\d+[a-z]+/io)
    
    begin
      @backpackapi = backpack_connection()
      @calendarapi = calendar_connection()
      @calendars = @calendarapi.calendars()
    rescue Exception => ex
      logger.info ex
      switch_ssl()
      if (@retry)
        @retry = false
        retry
      else
        logger.info "Both SSL and non-SSL connections to Backpack have failed for #{self.account.backpack_sitename}"
        return false
      end
    end
    
    # For each calendar
    @calendars.each { |calendar|
      
      # For each event in this calendar
      @calendarapi.calendar_events(calendar.id).each { |cal_event|
        
        # If the event has reminders defined store the event id for later
        if (cal_event.message =~ @reminder_pattern)
          # Reminders will be destroyed unless they're on this list
          @calendar_event_ids.push(cal_event.id)
        else
          # skip processing
          next
        end
        
        # Set the right time for display purposes
        if (cal_event.all_day)
          @event_occurs_at = cal_event.occurs_at
        else
          @event_occurs_at = cal_event.occurs_at + Time.zone_offset(Time.now.zone)
        end
        
        # Fetch all backpack_reminder records that we have for this calendar for this user
        @reminders = self.backpack_reminders.find(:all, :conditions => {:calendar_event_id => cal_event.id})
        
        logger.debug "#{@reminders.length} Reminders. Occurs at #{@event_occurs_at}"
        
        # If we're already managing reminders for this calendar event
        if (@reminders.length > 0)
          logger.debug "Reminder cleanup started"

          # If the event has been updated since we last processed it
          if (cal_event.updated_at > @reminders[0].event_updated_at)
            
            # Remove all existing reminders and backpack_reminders
            @reminders.each { |rem|
              logger.debug "Destroying reminder #{rem.reminder_id}"
              begin
                @backpackapi.destroy_reminder(rem.reminder_id)
              rescue Exception => ex
                logger.info("ERROR: Couldn't remove reminder_id #{rem.reminder_id}: #{ex.message}")
              else
                rem.destroy()
              end
            }
            
            logger.debug "Reminder cleanup complete"
          else
            next
          end
        end

        if (@event_occurs_at >= Time.now() && cal_event.message =~ @reminder_pattern)
          cal_event.message.scan(@reminder_pattern).each { |reminder|
            # Get the Reminder DateTime
            @reminder_datetime = get_reminder_datetime(reminder, @event_occurs_at)
            
###################################################################
# See comments below as to why this line is commented out.
###################################################################
#            @trimmed_title = cal_event.title
###################################################################
            
            # As long as the Reminder DateTime was set we know that the reminder tag was valid
            if (!@reminder_datetime)
              logger.info "Bad reminder tag #{reminder}"
            elsif (@reminder_datetime < Time.now())
              logger.info "Reminder Datetime (#{@reminder_datetime}) cannot be in the past"
            else
              # Build the text message for the Reminder
              @reminder_text = cal_event.message.gsub(@reminder_pattern, "").gsub(/^\s+|\s+$/o,"")
              if (cal_event.all_day)
                @reminder_text += " on #{@event_occurs_at.strftime("%a %b %d")}"
              else
                @reminder_text += " on #{@event_occurs_at.strftime("%a %b %d")} at #{@event_occurs_at.strftime('%I:%M %p')}"
              end
              
              logger.debug("Create reminder: #{@reminder_text} => #{@reminder_datetime.strftime('%m/%d/%Y %H:%M:%S')}")
              
              # Make the API call to create the Reminder
              @created_reminder = @backpackapi.create_reminder(@reminder_text, @reminder_datetime.strftime('%m/%d/%Y %H:%M:%S'))
              
              # Create a BackpackReminder to tie the @created_reminder to the current cal_event for this user
              self.backpack_reminders.create(
                :calendar_id => calendar.id,
                :calendar_event_id => cal_event.id,
                :account_user_id => self.id,
                :reminder_id => @created_reminder["id"].to_i,
                :event_updated_at => cal_event.updated_at + Time.zone_offset(Time.now.zone))
            end
          }

###################################################################
# The following code is to be used to strip the hashtags out of the
# calendar event but due to an API limitation that doesn't allow for
# updates to a specific value in the calendar event the entire event
# is being overwritten by the values we send. So in the case of a
# recurring event, since the API doesn't expose that setting to us
# we were inadvertently removing the recurrence upon updating the
# events. So we stopped stripping out the hashtags.
###################################################################
#          # Strip out only valid Reg
#          @trimmed_title = cal_event.title.gsub(@regex_all, "").gsub(/^\s+|\s+$/o,"")
#          
#          # Build a hash to update the Calendar Event with a new Title that has the reminder tags stripped out
#          @hash = {}
#          @hash[:title] = "#{@event_occurs_at.strftime('%m/%d/%Y')} #{@trimmed_title}"
#          @hash[:all_day] = cal_event.all_day
#          @hash[:remind] = cal_event.remind
#          unless (cal_event.occurs_until == nil)
#            @hash[:occurs_until] = (cal_event.occurs_until + Time.zone_offset(Time.now.zone)).strftime('%Y-%m-%d %H:%M:%S')
#          end
#          unless (cal_event.reminded_at == nil)
#            @hash[:reminded_at] = (cal_event.reminded_at + Time.zone_offset(Time.now.zone)).strftime('%Y-%m-%d %H:%M:%S')
#          end
#          
#          @calendarapi.update_calendar_event(cal_event.id, @hash)
###################################################################
        end
      }
      
      # Find backpack_reminders that no longer have calendar_events and destroy them
      @reminders = self.backpack_reminders.find(:all, :conditions => {:calendar_id => calendar.id})
      
      @reminders.each { |rem|
        logger.debug "Begin orphaned reminder cleanup"
        if (!@calendar_event_ids.include?(rem.calendar_event_id))
          logger.debug "Destroying reminder #{rem.reminder_id}"
          begin
            @backpackapi.destroy_reminder(rem.reminder_id)
          rescue Exception => ex
            logger.info("ERROR: Couldn't remove reminder_id #{rem.reminder_id}: #{ex.message}")
          else
            rem.destroy()
          end
        end
        logger.debug "End orphaned reminder cleanup"
      }
    }
    
    @my_account_user = AccountUser.find(:first, :conditions => {:user_id => self.user_id, :account_id => self.account_id})
    @my_account_user.processed_at = Time.now()
    @my_account_user.save!()
    
    logger.info "User #{self.user.full_name} processed at #{@my_account_user.processed_at.strftime('%Y-%m-%d %H:%M:%S')}"
  end
  
  def get_reminder_datetime(reminder, event_occurs_at)
    @amount_of_time = reminder[reminder.index(/\d/)..reminder.rindex(/\d/)].to_i
    initialize_regex()
    
    case
      when reminder.match(@regex_year)
        event_occurs_at - @amount_of_time.year
      when reminder.match(@regex_month)
        event_occurs_at - @amount_of_time.month
      when reminder.match(@regex_week)
        event_occurs_at - @amount_of_time.week
      when reminder.match(@regex_day)
        event_occurs_at - @amount_of_time.day
      when reminder.match(@regex_hour)
        event_occurs_at - @amount_of_time.hour
      when reminder.match(@regex_minute)
        event_occurs_at - @amount_of_time.minute
      else
        false
    end
  end
  
  def self.next_for_reminders(amount_to_fetch = nil)
    if (amount_to_fetch == nil)
      AccountUser.find(:all, :joins => "INNER JOIN accounts ON accounts.id = account_users.account_id INNER JOIN plans ON accounts.plan_id = plans.id", :conditions => "(processed_at IS NULL OR TIME_TO_SEC(TIMEDIFF(NOW(), processed_at)) >= plans.update_interval) AND LENGTH(api_token) > 0 AND accounts.next_bill_date >= DATE(NOW())")
    else
      AccountUser.find(:all, :joins => "INNER JOIN accounts ON accounts.id = account_users.account_id INNER JOIN plans ON accounts.plan_id = plans.id", :conditions => "(processed_at IS NULL OR TIME_TO_SEC(TIMEDIFF(NOW(), processed_at)) >= plans.update_interval) AND LENGTH(api_token) > 0 AND accounts.next_bill_date >= DATE(NOW())", :limit => amount_to_fetch)
    end
  end
  
  private
  
  def switch_ssl()
    self.account.ssl_required = !self.account.ssl_required
    self.account.save()
    logger.info "Connection ssl_required changed to #{self.account.ssl_required} for account #{self.account_id}."
  end
  
  def calendar_connection()
    @http = (self.account.ssl_required) ? "https" : "http"
    Backpack::Calendar.new("#{@http}://#{self.account.backpack_sitename}.backpackit.com", self.api_token)
  end
  
  def backpack_connection()
    Backpack::Backpack.new(self.account.backpack_sitename, self.api_token, self.account.ssl_required)
  end
  
  def initialize_regex()
    @regex_year = Regexp.new(/\#rem\d+(years|year|yrs|yr)\s?/io)
    @regex_month = Regexp.new(/\#rem\d+(months|month|mon|mo)\s?/io)
    @regex_week = Regexp.new(/\#rem\d+(weeks|week|wks|wk|w)\s?/io)
    @regex_day = Regexp.new(/\#rem\d+(days|day|dys|dy|d)\s?/io)
    @regex_hour = Regexp.new(/\#rem\d+(hours|hour|hrs|hr|h)\s?/io)
    @regex_minute = Regexp.new(/\#rem\d+(minutes|minute|mins|min|m\s?)/io)
    @regex_all = Regexp.union(@regex_year, @regex_month, @regex_week, @regex_day, @regex_hour, @regex_minute)
  end
end
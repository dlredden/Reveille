class BackpackRemindersController < ApplicationController
  before_filter :authorize_access, :validate_account, :set_current_section
  layout "app"
  
  # GET /backpack_reminders
  # GET /backpack_reminders.xml
  def set_current_section
      @current_section = "schedule"
  end
    
  def index
    @account_user = AccountUser.find(:first, :conditions => {:user_id => current_user, :account_id => current_account})
    @reveille_reminders = @account_user.backpack_reminders.find(:all)
    
    # Get the calendar info from Backpack
    @calendars = {}
    begin
      @account_user.calendars().each { |cal|
        @calendars[cal.id] = {"id" => cal.id.to_s, "name" => cal.name, "shared" => cal.shared_with_all_users, "events" => {}}
      }
    rescue
      logger.error "Error: Couldn't retrieve calendars from Backpack for #{@account_user.id.to_s}"
    end
    
    # Get the reminder info from Backpack
    @reminders = {}
    begin
      @account_user.reminders().each { |rem|
        @reminders[rem.id] = rem
      }
    rescue
      logger.error "Error: Couldn't retrieve reminders from Backpack for #{@account_user.account_id.to_s}:#{@account_user.user_id.to_s}"
    end
    
    # Now lookup the Reveille reminders and merge the @reminders into @calendars
    @reveille_reminders.each { |reminder|
      if (@reminders[reminder.reminder_id])
        logger.debug "Testing:#{@calendars}"
        if (@calendars[reminder.calendar_id]["events"][reminder.calendar_event_id])
          @calendars[reminder.calendar_id]["events"][reminder.calendar_event_id]["reminders"].push(@reminders[reminder.reminder_id])
        else
          begin
            @event = @account_user.calendar_event(reminder.calendar_event_id)
            if (@event)
              @calendars[reminder.calendar_id]["events"][reminder.calendar_event_id] = {"event" => @event, "reminders" => [@reminders[reminder.reminder_id]]}
            end
          rescue
            #reminder.destroy()
          end
        end
      else
        #reminder.destroy()
      end
    }
    
    # Remove any Calendars that don't have any Reveille reminders defined for them
    @calendars.delete_if { |key, value| value["events"].length == 0}

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @calendars }
    end
  end

  # GET /backpack_reminders/1
  # GET /backpack_reminders/1.xml
  def show
    @backpack_reminders = BackpackReminder.find_by_user_id_and_id(current_user(), params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @backpack_reminder }
    end
  end

  # GET /backpack_reminders/new
  # GET /backpack_reminders/new.xml
  def new
    @backpack_reminder = BackpackReminder.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @backpack_reminder }
    end
  end

  # GET /backpack_reminders/1/edit
  def edit
    @backpack_reminder = BackpackReminder.find_by_user_id_and_id(current_user(), params[:id])
  end

  # POST /backpack_reminders
  # POST /backpack_reminders.xml
  def create
    @backpack_reminder = BackpackReminder.new(params[:backpack_reminder])

    respond_to do |format|
      if @backpack_reminder.save
        flash[:notice] = 'BackpackReminder was successfully created.'
        format.html { redirect_to(@backpack_reminder) }
        format.xml  { render :xml => @backpack_reminder, :status => :created, :location => @backpack_reminder }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @backpack_reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /backpack_reminders/1
  # PUT /backpack_reminders/1.xml
  def update
    @backpack_reminder = BackpackReminder.find_by_user_id_and_id(current_user(), params[:id])

    respond_to do |format|
      if @backpack_reminder.update_attributes(params[:backpack_reminder])
        flash[:notice] = 'BackpackReminder was successfully updated.'
        format.html { redirect_to(@backpack_reminder) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @backpack_reminder.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /backpack_reminders/1
  # DELETE /backpack_reminders/1.xml
  def destroy
    @backpack_reminder = BackpackReminder.find_by_user_id_and_id(current_user(), params[:id])
    @backpack_reminder.destroy

    respond_to do |format|
      format.html { redirect_to(backpack_reminders_url) }
      format.xml  { head :ok }
    end
  end
end

class UsersController < ApplicationController
  before_filter :authorize_access, :validate_account, :except => [:cancel_reset_password, :reset_password, :reset_password_form, :index, :login, :send_login, :signup, :send_signup, :logout]
  in_place_edit_for :user, :first_name
  in_place_edit_for :user, :last_name
  in_place_edit_for :user, :email
  layout "app"
  
  def index()
    render(:action => 'login')
  end
  
  def login()
    flash[:notice] = nil
    if (session[:user_id] != nil)
      redirect_to(:controller => 'reminders')
    elsif (params[:email] && params[:password])
      @found_user = User.authenticate(params[:email], params[:password])
      
      if (@found_user)
        session[:user_id] = @found_user.id
        session[:account_id] = @found_user.account_users.first().account_id
        redirect_to(:controller => 'login')
      else
        flash[:notice] = "Either the username or password that you entered is incorrect."
      end
    end
  end
  
  def change_password()
    @user = User.find(session[:user_id])
    @user.password = params[:password]
    @user.password_confirmation = params[:password_confirmation]
    
    respond_to do |format|
      if (@user.save())
        format.xml { render(:xml => @user.to_xml) }
        format.js { render(:action => "password_update") }
      else
        @error = true
        format.xml  { render(:xml => @user.error.to_xml) }
        format.js { render :action => "password_update" }
      end
    end
  end

  def logout()
    session[:user_id] = nil
    session[:account_id] = nil
    flash[:notice] = "You are now logged out."
    redirect_to(:controller => 'login')
  end
  
  def signup()
    build_cc_dropdown_arrays()
    @user = User.new()
    @account = Account.new()
    @payment = Payment.new()
    @account_user = AccountUser.new()
    @plans = Plan.find(:all, :order => "price DESC", :conditions => {:active => true, })
    render :action => "signup", :layout => "marketing"
  end
  
  def send_signup()
    @user = User.new(params[:user])
    @account = Account.new(params[:account])
    @account.next_bill_date = Date.today() + 1.month
    @payment = @account.build_payment(params[:payment])
    @account_user = @user.account_users.build(:account => @account)
    Rails.logger.info(params[:account_user])
    @account_user.api_token = params[:account_user]["api_token"]
    @account_user.role = "Admin"
    
    if (@user.save)
      session[:user_id] = @user.id
      session[:account_id] = @account.id
      flash[:notice] = "Thanks for trying us out. We hope that you find Reveille as useful as we do."
      Mailer.deliver_thanks_for_signing_up(@user)
      redirect_to(:controller => "reminders")
    else
      flash[:notice] = "Account creation failed."
      build_cc_dropdown_arrays()
      render(:action => 'signup', :layout => "marketing")
    end
  end
  
  def cancel_reset_password
    respond_to do |format|
      format.js
    end
  end
  
  def reset_password_form
    flash.delete(:notice)
    respond_to do |format|
      format.js
    end
  end
  
  def reset_password
    flash[:notice] = nil
    
    if (params[:email] == nil)
      flash[:notice] = "Please supply a valid email address"
    elsif (params[:email] !~ /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/io)
      flash[:notice] = "Please supply a valid email address"
    else
      @user = User.find_by_email(params[:email])
      if (@user == nil)
        logger.warn("WARN: Password reset email address is invalid, #{params[:email]}")
      else
        @password = User.generate_password()
        @user.password = @password
        
        begin
          @user.save
        rescue Exception => ex
          logger.info("ERROR: Password reset failed for user #{@user.id}. Error details: #{ex.message}")
          flash[:error] = "Password reset failed. Please try again."
        else
          begin
            flash[:notice] = "Your password has been reset. Check your email to get your new passord."
            Mailer.deliver_reset_passord(@user, @password)
          rescue Exception => ex1
            logger.info("ERROR: Password reset failed to send the new password #{@password} to user #{@user.email}. Error details: #{ex1.message}")
            flash[:error] = "Password reset failed. Please try again."
          end
          
        end
      end
    end
    
    respond_to do |format|
      format.js
    end
  end

  # GET /users/1
  # GET /users/1.xml
  def show
    @user = User.find(params[:id])
		@reminders = @user.reminders
		
    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/new
  # GET /users/new.xml
  def new
    @user = User.new()

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user }
    end
  end

  # GET /users/1/edit
  def edit
    @user = User.find(params[:id])
  end

  # POST /users
  # POST /users.xml
  def create
    @user = User.new(params[:user])

    respond_to do |format|
      if @user.save
        flash[:notice] = 'User was successfully created.'
        format.html { redirect_to(@user) }
        format.xml  { render :xml => @user, :status => :created, :location => @user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /users/1
  # PUT /users/1.xml
  def update
    @user = User.find(params[:id])

    respond_to do |format|
      if @user.update_attributes(params[:user])
        flash[:notice] = 'User was successfully updated.'
        format.html { redirect_to(@user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.xml
  def destroy
    @user = User.find(params[:id])
    @user.destroy

    respond_to do |format|
      format.html { redirect_to(users_url) }
      format.xml  { head :ok }
    end
  end
end

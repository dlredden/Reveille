class AccountUsersController < ApplicationController
  in_place_edit_for :account_user, :api_token
  
  # GET /account_users
  # GET /account_users.xml
  def index
    @account_users = AccountUser.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @account_users }
    end
  end

  # GET /account_users/1
  # GET /account_users/1.xml
  def show
    @account_user = AccountUser.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @account_user }
    end
  end

  # GET /account_users/new
  # GET /account_users/new.xml
  def new
    @account_user = AccountUser.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @account_user }
    end
  end

  # GET /account_users/1/edit
  def edit
    @account_user = AccountUser.find(params[:id])
  end
  
  def invite_user
    @account = Account.find(current_account)
    @password = User.generate_password()
    @inviter = User.find(current_user)
    @user = User.find_or_create_by_email(:email => params[:email], :first_name => params[:first_name], :last_name => params[:last_name], :password => @password)
    @account_user = AccountUser.new(:account => @account, :role => "User", :user => @user)
    
    respond_to do |format|
      if (@account_user.save)
        begin
          Mailer.deliver_invite_user(@user, @password, @inviter.first_name)
        rescue Exception => ex
          logger.info "User creation succeded for #{@user.email} but the email failed to send: #{ex.message}"
        end
      else
        logger.info "User creation failed for #{@account.id}:#{@user.email}"
        flash[:error] = "User creation failed for #{@user.full_name}"
      end
      format.js
    end
  end

  # POST /account_users
  # POST /account_users.xml
  def create
    @account_user = AccountUser.new(params[:account_user])

    respond_to do |format|
      if @account_user.save
        flash[:notice] = 'AccountUser was successfully created.'
        format.html { redirect_to(@account_user) }
        format.xml  { render :xml => @account_user, :status => :created, :location => @account_user }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @account_user.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /account_users/1
  # PUT /account_users/1.xml
  def update
    @account_user = AccountUser.find(params[:id])

    respond_to do |format|
      if @account_user.update_attributes(params[:account_user])
        flash[:notice] = 'AccountUser was successfully updated.'
        format.html { redirect_to(@account_user) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @account_user.errors, :status => :unprocessable_entity }
      end
    end
  end
  
  def change_user_role()
    @account_user = AccountUser.find(params[:id])
    @message_label = params[:message_label]
    
    if (params[:checked] == "true")
      @account_user.role = "Admin"
    else
      @account_user.role = "User"
    end

    Rails.logger.info("AccountUserId: #{@account_user.id}, Role: #{@account_user.role}")
    
    @account_user.save()
    
#    respond_to do |format|
#      if (@account_user.save())
#        @message = 'Account User was successfully updated.'
#        @error = false
#        format.js { render(:action => "change_user_role") }
#      else
#        @error = true
#        @message = 'Account User update failed.'
#        format.js { render(:action => "change_user_role") }
#      end
#    end
  end

  # DELETE /account_users/1
  # DELETE /account_users/1.xml
  def destroy
    @account_user = AccountUser.find(params[:id])
    @account_user.destroy()

    respond_to do |format|
      format.html { redirect_to(account_users_url) }
      format.xml  { head :ok }
      format.js
    end
  end
end

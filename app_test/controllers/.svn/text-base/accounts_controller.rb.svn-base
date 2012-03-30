class AccountsController < ApplicationController
  before_filter :authorize_access, :set_current_section
  in_place_edit_for :account, :backpack_sitename
  in_place_edit_for :account, :requires_ssl
  in_place_edit_for :account, :org_name
  layout "app"
  
  def set_current_section
      @current_section = "settings"
  end
  
  def index
    @user = User.find(current_user)
    @account = Account.find(current_account)
    @account_user = @user.account_users.first(:conditions => {:account_id => current_account})
  end
  
  def change_ssl
    @account = Account.find(params[:id])
    @account.requires_ssl = params[:checked] #!@account.requires_ssl
    @account.save!
  end
  
  def cancel
    @account = Account.find(params[:id])
    
    if (params[:is_canceled] == "true")
      @account.is_canceled = true;
    else
      @account.is_canceled = false;
    end
    
    respond_to do |format|
      if (@account.save())
        format.js
      else
        flash[:error] = "Account cancelation failed"
        format.js
      end
    end
  end
  
  def destroy
    @account = Account.find(params[:id])
    @account.destroy()
    
    respond_to do |format|
      format.html { redirect_to("/")}
      format.xml { redirect_to("/")}
      format.js { redirect_to("/")}
    end
  end
end

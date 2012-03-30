# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  before_filter :redirect_to_ssl
  
  protect_from_forgery # See ActionController::RequestForgeryProtection for details
  session = {:key => "_wikid_labs_reveille_"}
  
  private #------------

  LabelValue = Struct.new(:id,:value)
  
  def build_cc_dropdown_arrays
    @cctypes = Selectvalue.find(:all, :conditions => {:key => "cctype"})
    @ccmonths = Selectvalue.find(:all, :conditions => {:key => "ccmonthdropdown"})
    @yearsArray = (Date.today.year..Date.today.year + 15).entries #(2009..2024).entries
    @yearsCollection = @yearsArray.collect {|yr| LabelValue.new(yr,yr)}
  end
  
  def authorize_access
    if (session[:user_id] == nil)
      flash[:notice] = "Please log in."
      redirect_to(:controller => 'login')
      return false
    end 
  end
  
  def validate_account
    @account_user = AccountUser.find(:first, :conditions => {:account_id => current_account, :user_id => current_user})
    
    if (@account_user.account.next_bill_date < Date.today())
     redirect_to(:controller => 'account')
    end
  end
  
  def set_current_account
    @current_account ||= User.find(current_user())
  end
  
  def current_user
    session[:user_id]
  end
  
  def current_account
    session[:account_id]
  end
  
  def redirect_to_ssl
    redirect_to :protocol => "https://" unless (request.ssl? || local_request? || ENV['RAILS_ENV'] = "development")
  end
  
  helper_method :current_user, :current_account, :build_cc_dropdown_arrays
end

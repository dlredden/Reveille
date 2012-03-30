class PaymentsController < ApplicationController
  before_filter :authorize_access, :validate_account
  
  def update_billing()
    @updated = false
    @payment = Account.find(current_account).payment
    build_cc_dropdown_arrays()
    
    respond_to do |format|
      format.xml  { render(:xml => @payment.error.to_xml) }
      format.js { render(:action => "billing_update") }
    end
  end
  
  def billing_details
    @account = Account.find(current_account)
  end
  
  def send_billing_update
    @updated = false
    @payment = Account.find(current_account).payment
    
    if @payment.nil?
    	Rails.logger.info("No Payment Info for this Account.  Going to create it now.")
    	@account = Account.find(current_account)
    	@payment = @account.build_payment(params[:payment])
    else
	    if (params[:commit] == "cancel")
	      @updated = true
	    else
	      @payment.name = params[:payment][:name]
	      @payment.number = params[:payment][:number]
	      @payment.cvv_number = params[:payment][:cvv_number]
	      @payment.exp_month = params[:payment][:exp_month]
	      @payment.exp_year = params[:payment][:exp_year]
	
	      #Rails.logger.info("New Payment: id=#{@payment.id.to_s}, name=#{@payment.name.to_s}, number=#{@payment.cc_number.to_s}, cvv=#{@payment.cvv.to_s}, exp_month=#{@payment.exp_month.to_s}, exp_year=#{@payment.exp_year.to_s}")
	    end
	end
	if (@payment.save())
		@updated = true
   end
    
    respond_to do |format|
      format.xml  { render(:xml => @payment.error.to_xml) }
      format.js { render(:action => "billing_update") }
    end
  end
end
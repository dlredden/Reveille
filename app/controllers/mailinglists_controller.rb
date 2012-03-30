class MailinglistsController < ApplicationController
  def new
	@mailinglist = Mailinglist.new
  end

  def create
	@mailinglist = Mailinglist.new(params[:mailinglist])
	respond_to do |format|
		if @mailinglist.save
			format.html { redirect_to url('/') }
			format.xml { head :created, :location => url(@mailinglist) }
			format.js {render :action => 'create' }
		else
			@error = true
			format.html { render :action => 'new' }
			format.xml  { render xml => @mailinglist.error.to_xml }
			format.js { render :action => 'create' }
		end
	end
  end

  def edit
  end

  def delete
  end

end

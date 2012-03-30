class Mailinglist < ActiveRecord::Base
	validates_uniqueness_of :email_address, :message => 'is already on our mailing list.'
	validates_presence_of	:email_address, :message => 'field was blank.<br>Please enter an email address.'
	validates_format_of :email_address, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i, :on => :save, :message => 'wasn\'t recognized.<br>Please enter a valid email address.'
end

class Mailer < ActionMailer::Base
  @@from_email = "Reveille@wikidlabs.com"
  
  def invite_user(user, password, inviter)
  	# Email body is in invite_user mailer view
    recipients  "#{user.full_name} <#{user.email}>"
    from        @@from_email
    subject     "You've been invited to use Reveille"
    body['inviter'] = inviter
    body['user'] = user
    body['password'] = password
  end
  
  def reset_password(user, password)
  	# Email body is in reset_password mailer view
    recipients  "#{user.full_name} <#{user.email}>"
    from        @@from_email
    subject     "Reveille Password Reset"
	body['password'] = password
  end
  
  def thanks_for_signing_up(user)
    recipients  "#{user.full_name} <#{user.email}>"
    from        @@from_email
    subject     "Welcome to Reveille"
  end
  
end

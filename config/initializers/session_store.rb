# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_reveille_session',
  :secret      => '1757076b5f9f85f42c988a23ee6ed9cc8c7e523d0bf5d6b64e934aaab598fb101b54407022a46e39a3f52a8ca18e06a7a6ef4298e2555587a1c2ccd4fec7156a'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

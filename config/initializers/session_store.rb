# Be sure to restart your server when you modify this file.

# Your secret key for verifying cookie session data integrity.
# If you change this key, all old sessions will become invalid!
# Make sure the secret is at least 30 characters and all random, 
# no regular words or you'll be exposed to dictionary attacks.
ActionController::Base.session = {
  :key         => '_loan_co_session',
  :secret      => '9b329bf9f445cee3b581902d485c80b11c075aa35ef3656ce3f4261ad382ba820577eab4b9ee2fbce76bf3974d268d46ac327ab386e523a0197802a8fff5a299'
}

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rake db:sessions:create")
# ActionController::Base.session_store = :active_record_store

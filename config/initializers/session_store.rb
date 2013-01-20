# Be sure to restart your server when you modify this file.

require'action_dispatch/middleware/session/dalli_store'
CnameQRV4::Application.config.session_store :dalli_store
CnameQRV4::Application.config.session_options  = {:cookie_only => false}
##CnameQRV4::Application.config.session_store :cookie_store, :key => '_cname_qrv4_session'

# Use the database for sessions instead of the cookie-based default,
# which shouldn't be used to store highly confidential information
# (create the session table with "rails generate session_migration")
# CnameQRV4::Application.config.session_store :active_record_store

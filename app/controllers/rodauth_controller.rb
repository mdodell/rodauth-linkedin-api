class RodauthController < ApplicationController
  # used by Rodauth for rendering views, CSRF protection, and running any
  # registered action callbacks and rescue_from handlers
  def omniauth
    auth = request.env["omniauth.auth"]

    debugger
    # attempt to find existing identity directly
    identity = AccountIdentity.find_by(provider: auth["provider"], uid: auth["uid"])

    if identity
      # update any external info changes
      identity.update!(info: auth["info"])
      # set account from identity
      account = identity.account
    end

    # attempt to find an existing account by email
    account ||= Account.find_by(email: auth["info"]["email"])

    # disallow login if account is not verified
    if account && account.status != "verified"
      redirect_to rodauth.login_path, alert: rodauth.unverified_account_message
      return
    end

    # create new account if it doesn't exist
    unless account
      account = Account.create!(email: auth["info"]["email"], status: rodauth.account_open_status_value, name: auth["info"]["first_name"])
    end

    # create new identity if it doesn't exist
    unless identity
      account.identities.create!(provider: auth["provider"], uid: auth["uid"], info: auth["info"])
    end

    # load the account into the rodauth instance
    rodauth.account_from_login(account.email)

    rodauth_response do # ensures any `after_action` callbacks get called
      # sign in the loaded account
      rodauth.login("omniauth")
    end


  end
end

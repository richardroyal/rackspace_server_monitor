class UserMailer < ActionMailer::Base
  default from: "admin@example.com"

  def server_outage_mailer( user, server, restarting )
    @user = user
    @server = server
    @restarting = restarting
    mail( :to => user.email, :subject => "Server Outage Detected: #{server.name}" )
  end

end

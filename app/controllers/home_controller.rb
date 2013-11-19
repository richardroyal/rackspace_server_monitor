class HomeController < ApplicationController

  before_filter :authenticate_user!

  def index
    @servers = Server.order("servers.name ASC")
    @outages = Check.recent_outages
  end
end

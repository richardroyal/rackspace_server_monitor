class Server < ActiveRecord::Base
  
  # Config
  attr_accessible :name, :return_value, :url, :rackspace_id

  # Associates
  has_and_belongs_to_many :users
  has_many :checks, :dependent => :destroy

  # Validations
  validates :name, :url, :presence => true


  # All possible states for a server, full string is stored in check database.
  STATES = [ "Site up and returning correct value.",
             "Site up and not returning correct value.",
             "URI response code not 200.",
             "Could not resolve DNS.",
             "Not checked."]


  
  # Check if server is responsive and returning expected value
  def check
    require "net/http"
    require "uri"
    begin
      response = Net::HTTP.get_response( URI.parse(self.url) )
      if response.code.to_s == "200"
        if response.body.to_s.strip.include?( self.return_value.strip )
          return STATES[0]
        else
          return STATES[1]
        end
      else
        return STATES[2]
      end
    rescue
      return STATES[3]
    end
  end


  # Get current status.
  def current_status
    if !self.checks.blank?
      current_state = self.checks.first.state
      if current_state == STATES[0]
        return "up"
      else
        return current_state
      end
    else
      return STATES[4]
    end
  end


  # Get current action.
  def current_action
    if self.checks.blank?
      "Waiting on first check."
    else
       self.checks.first.action
    end
  end




  # List of servers in Rackspace account.
  # Returns errors for API key misconfiguration.
  def self.rackspace_servers
    username = ENV['RACKSPACE_API_USERNAME']
    api_key = ENV['RACKSPACE_API_KEY']

    begin

      servers = []

      # Get Gen2 Servers from rackspace region :dfw
      s = self.get_server_group(username, api_key, "v2", "dfw")
      servers << s if !s.blank?

      # Get Gen2 Servers from rackspace region :ord
      s = self.get_server_group(username, api_key, "v2", "ord")
      servers << s if !s.blank?

      # Get Gen1 Servers from rackspace region :ord
      s = self.get_server_group(username, api_key, "v1", "ord")
      servers << s if !s.blank?

      return servers.flatten.sort{ |a, b| a.name <=> b.name }
    rescue
      return "invalid api key"
    end
  end


  #  Get Rackspace server objects from a specified group
  def self.get_server_group( username, api_key, version, region )
    service = Fog::Compute.new({ 
                     :provider => 'Rackspace', 
                     :rackspace_username  => username, 
                     :rackspace_api_key => api_key, 
                     :version => version.to_sym, 
                     :rackspace_region => region.to_sym })

    service.servers 
  end




  # Send Force Restart command via Rackspace API
  def send_restart

    if self.rackspace_id and BooleanSetting.get_setting( "API Restarts" )
      username = ENV['RACKSPACE_API_USERNAME']
      api_key = ENV['RACKSPACE_API_KEY']

      begin

        servers = Server.rackspace_servers
        restart = '';

        if servers.is_a?(Array)
          servers.each do |server|
            if server.id == self.rackspace_id
              restart = server
            end
          end
        end

        UserMailer.server_outage_mailer( User.first, self, true ).deliver
        restart.reboot("HARD")

      rescue
        return "invalid api key or rackspace server id"
      end
    else
      UserMailer.server_outage_mailer( User.first, self, false ).deliver
      return "restarts turned off"
    end

  end


end

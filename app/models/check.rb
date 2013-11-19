class Check < ActiveRecord::Base
  
  # Associations
  belongs_to :server
  attr_accessible :state, :action

  # Scopes
  default_scope order('id DESC')
  scope :recent_outages, where("checks.state != ?", Server::STATES[0] ).limit(5)

  


  # Calls the check method on each server and stores the
  # state of the server from Server::STATES. Uses Rackspace API
  # to restart servers based on logic. Can turn off API calls in 
  # in dashboard settings for logged in user.
  #
  # LOGIC:
  #  If last saved state is "up" and ...
  #     - returning correct value, save state (up).
  #     - not returning correct value, send restart. Check action "Restarting.".
  #  If last saved state is not "up" and ...
  #     - returning correct value, save state (up).
  #     - not returning correct value, email admin. Check action "Requires admin."
  #  
  #  Always ...
  #     - the new check state is the returned value from s.check.
  def self.run
  
    send_restart = BooleanSetting.get_setting( "API Restarts" )
    Check.manage_check_records_database_size

    Server.all.each do |s|

      previous_state = s.checks.first
      new_state = s.check
      action = ''

      if previous_state.blank?
        s.checks.new( :state => new_state, :action => '' )
        s.save
      else

        if previous_state.state == Server::STATES[0]
          if new_state == Server::STATES[0]
            action = ''
          else
            if send_restart
              action = "Restarting."
              s.send_restart
            else
              action = "Not restarting."
            end
          end
  
        else
          if new_state == Server::STATES[0]
            action = ''
          elsif previous_state.action == "Restarting."
            action = 'Waiting for restart to complete or requires admin.'
          else
            action = 'Waiting for restart to complete or requires admin.'
          end
        end
  
        s.checks.new( :state => new_state, :action => action )
        s.save
      end
    end
  end






  # Cleans check record out by count according to setting.
  # Allows for app to run continuously within database size constraint.
  # Assumes new check records are about to be created and downsizes by
  # number of servers as well.
  def self.manage_check_records_database_size
    max = Setting.get_setting("Max Check Records").to_i - Server.count
    current = Check.count
    if current >= max
      difference = current - max
      Check.unscoped.find( :all, :order => "id ASC", :limit => difference ).collect{ |r| r.destroy }
    end
  end


end

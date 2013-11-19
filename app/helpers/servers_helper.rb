module ServersHelper

  # Convert server status into a labeled span for pretty display
  def status_label( state )
    c = "label "
    if state == "up"
      c += "label-success" if state == "up"
    else
      c += "label-important"
    end
    content_tag( :span, state, :class => c) 
  end


  # List of local server objects that have associated Rackspace Server
  def list_associated_rackspace_servers( rackspace_id )
    rid = rackspace_id.to_s.gsub(' ', '')
    associated_servers = Server.where( :rackspace_id => rid )
    l = []
    associated_servers.each do |s|
      l << link_to( s.name, server_path( s ) )
    end
    l.join(", ").html_safe
  end


end

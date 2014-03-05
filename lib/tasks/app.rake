namespace :app do

  desc "Create roles."
  task :create_roles => :environment do
    User.delete_all
    Role.delete_all

    roles = User::ALL_ROLES

    puts "Creating roles: #{roles.join(', ')}."
    roles.collect{ |r| Role.create( :name => r ) }

  end

  desc "Create initial admin user."
  task :create_initial_admin_user => :environment do
    User.delete_all

    email = "admin@example.com"
    pw = "11111111"
    puts "Creating user #{email}, #{pw}. Make sure to change on production."
    User.create!( :email => email, :password => pw, :password_confirmation => pw, :name => 'Administrator' )
    u = User.first
    u.add_role(:admin)

  end


  desc "Check all servers"
  task :check_all_servers => :environment do
    Check.run
  end




  desc "Run all launch tasks"
  task :launch => [ :create_roles, :create_initial_admin_user ]

end

## Simple Rackspace Cloud Server Monitor

Setup your Cloud Servers with your Rackspace API credentials and have the app monitor your applications and restart servers when necessary...all while you sleep! 

### Getting Started

```
# Clone and enter repo
rake db:migrate
rake app:launch

# Rename config file and fill out the template with your credentials
mv config/application.example.yml config/application.yml

```

Go through the app and modify emails and MTA as needed.

Setup your Servers and expected return values.

Modify admin user account email to have notifications reach the correct email address.

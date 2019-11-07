set -e

# Configure Logging
curl -s "https://storage.googleapis.com/signals-agents/logging/google-fluentd-install.sh" | bash
cat >/etc/google-fluentd/config.d/railsapp.conf << EOF
<source>
  type tail
  format none
  path /opt/app/todos-api/log/*.log
  read_from_head true
  tag railsapp
</source
EOF

service google-fluentd restart &


# Install dependencies from apt
apt-get update
apt-get install -y git ruby ruby-dev build-essential libxml2-dev zlib1g-dev nginx libmysqlclient-dev libsqlite3-dev redis-server

gem install bundler --no-ri --no-rdoc

mkdir /opt/gem
chown -R railsapp:railsapp /opt/gem

sudo -u railsapp -H bundle install --path /opt/gem
sudo -u railsapp -H bundle exec rake assets:precompile

systemctl enable redis-server.service
systemctl start redis-server.service

cat default-nginx > /etc/nginx/sites-available/default
systemctl restart nginx.service

cat railsapp.service > /lib/systemd/system/railsapp.service
systemctl enable railsapp.service
systemctl start railsapp.service

# TODO: Background worker.

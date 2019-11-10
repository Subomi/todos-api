set -e

# Talk to the metadata server to get the project id
PROJECTID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
SECRET_KEY_BASE=$(curl -s "http://metadata.google.internal/computeMetadata/v1/instance/attributes/secret-key-base" -H "Metadata-Flavor: Google")
REPO_NAME="todos-api"
env_key=SECRET_KEY_BASE
env_file=~/.bashrc

temp_cmd="export $env_key=$SECRET_KEY_BASE"
perm_cmd="grep -q -F '$temp_cmd' $env_file || echo '$temp_cmd' >> $env_file"
eval $perm_cmd

# TODO: ssh things.
eval "$(ssh-agent)"
ssh-add ~/.ssh/id_rsa

# Get source code
rm -rf /opt/app
mkdir /opt/app

git clone git@github.com:Subomi/todos-api.git /opt/app -b master

pushd /opt/app/ops/

chmod 700 *

/opt/app/ops/configure.sh

set -e

# Talk to the metadata server to get the project id
PROJECTID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
REPO_NAME="todos-api"

# TODO: ssh things.
eval "$(ssh-agent)"
ssh-add ~/.ssh/id_rsa

# Get source code
rm -rf /opt/app
mkdir /opt/app

git clone git@github.com:Subomi/todos-api.git /opt/app -b master

/opt/app/ops/configure.sh

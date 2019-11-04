set -e

# Talk to the metadata server to get the project id
PROJECTID=$(curl -s "http://metadata.google.internal/computeMetadata/v1/project/project-id" -H "Metadata-Flavor: Google")
REPO_NAME="todos-api"

# Get source code
git clone git@github.com:akabiru/todos-api.git

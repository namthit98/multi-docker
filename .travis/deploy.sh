#!/bin/bash

eval "$(ssh-agent -s)" # Start ssh-agent cache
chmod 600 .travis/id_rsa # Allow read access to the private key
ssh-add .travis/id_rsa # Add the private key to SSH

git config --global push.default simple
git remote add deploy ssh://namthit98@$IP/$DEPLOY_DIR
git push deploy master

# Skip this command if you don't need to execute any additional commands after deploying.
ssh -T namthit98@$IP <<EOF
  cd $DEPLOY_DIR
  docker-compose down
  docker-compose -f docker-compose.prod.yml up --build -d
EOF
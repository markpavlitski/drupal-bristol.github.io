#!/bin/bash

ENV="prod"
DATE=`date`
CURRENT_BRANCH=`git symbolic-ref --short HEAD`
REMOTE_NAME=`git config --get branch.${CURRENT_BRANCH}.remote`
REMOTE_BRANCH="master"
REPO_URL=`git config --get remote.${REMOTE_NAME}.url`
DEPLOY_DIR=".deploy-github-pages"

echo ${DATE}

# Clone a fresh version of the repo into a new directory.
git clone ${REPO_URL} --quiet --branch ${REMOTE_BRANCH} ${DEPLOY_DIR}

# Push the current branch.
git push ${REMOTE_NAME} ${CURRENT_BRANCH}

# Delete the existing output and re-generate the site.
rm -rf output_${ENV}/
sculpin generate --quiet --env ${ENV}

# Copy the latest changes into the deploy directory.
cp -R output_prod/ ${DEPLOY_DIR}

pushd ${DEPLOY_DIR}
# Commit the changes with the datestamp, and force-push the changes.
git add --all
git status
git commit --quiet -m "${DATE}"
git push --force ${REMOTE_NAME} ${REMOTE_BRANCH}
popd

# Remove the deploy directory.
rm -rf ${DEPLOY_DIR}

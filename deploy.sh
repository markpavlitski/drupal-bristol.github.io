#!/bin/bash

ENV="prod"
DATE=`date`
CURRENT_BRANCH=`git symbolic-ref --short HEAD`
REMOTE_NAME=`git config --get branch.$(git current-branch).remote`
REMOTE_BRANCH="gh-pages"

# Push the current branch.
git push ${REMOTE_NAME} ${CURRENT_BRANCH}

# Delete the existing output.
rm -rf output_${ENV}/

# Re-generate the site.
sculpin generate -e ${ENV} -q

cp -R .git output_${ENV}/

pushd output_${ENV}/
# Commit the changes with the datestamp, and force-push the changes.
git checkout -B gh-pages && git stash
git fetch && git rebase ${REMOTE_NAME}/${REMOTE_BRANCH}
git stash pop && git add --all && git commit -m "${DATE}"
git push -f ${REMOTE_NAME} ${REMOTE_BRANCH}
popd

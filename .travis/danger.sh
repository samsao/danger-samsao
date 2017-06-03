#!/bin/sh -e

if [ "$TRAVIS_PULL_REQUEST" != "false" ]
then
  echo 'Danger ...'
  bundle exec danger
fi

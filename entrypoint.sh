#!/bin/bash

bundle install
rails db:prepare
rails assets:precompile
exec "$@"
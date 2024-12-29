#!/usr/bin/env bash

git add .
git commit -m "Release version 0.0.1"
git tag 0.0.1
git push hub_origin master --tags
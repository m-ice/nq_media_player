#!/usr/bin/env bash

git add .
git commit -m "Release version 1.0.0"
git tag 1.0.0
git push hub_origin master --tags
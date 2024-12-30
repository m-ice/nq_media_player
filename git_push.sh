#!/usr/bin/env bash

git add .
git commit -m "Release version 1.0.1"
git tag 1.0.1
git push hub_origin master
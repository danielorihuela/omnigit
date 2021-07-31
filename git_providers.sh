#!/bin/bash

GITHUB=0
GITLAB=1

# Providers names to show in items list
providers[GITHUB]="GitHub"
providers[GITLAB]="GitLab"

# Providers url to push the code
# Complete url example git@github.com:danielorihuela/omnigit.git
providers_url[GITHUB]="github.com"
providers_url[GITLAB]="gitlab.com"

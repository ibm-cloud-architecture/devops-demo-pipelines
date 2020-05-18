# Introduction
This repository contains multiple pipelines such as `artifactory-package-release-update`, `git-package-release-update` and
`mcm-pipelines`. You can view all the pipelines at `/pipelines/incubator`. It also contains a `./run.sh` script file which helps automate the process of deploying your pipelines on git.

There are multiple approaches on packaging and releasing your pipelines. Both the `artifactory-package-release-update` & `git-package-release-update` pipelines do the same thing, package, manage
and deploy your custom pipelines, except in different environments. For example, the `artifactory-package-release-update` pipeline, packages your
 pipelines and deploys them onto Artifactory, where as the `git-package-release-update` are deployed as git releases.

The `mcm-pipelines` contains the tasks of building, testing, pushing an image and a healthcheck of a nodejs application. It also
does a `sonar-scan` for code coverage.

# Requirements
Openshift ICP4A (Cloudpak for Apps) or a local instance of minikube with Kabanero 0.6.0 installed
An Artifactory account

 
# Deploy pipelines via Artifactory

# Deploy pipelines via Git Releases

# Deploy pipelines via the `run.sh`

[![asciicast](https://asciinema.org/a/315675.svg)](https://asciinema.org/a/315675)

# Deploy pipelines manually 


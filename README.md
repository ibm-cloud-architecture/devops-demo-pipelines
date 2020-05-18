## Table of Contents
  * [Introduction](#introduction)
  * [Pre-requisites](#pre-requisites)
  * [Deploy pipelines on Artifactory](#deploy-pipelines-on-artifactory)
  * [Deploy pipelines on Git Manually](#deploy-pipelines-on-git-manually)
  * [Deploy pipelines on Git Automated](#deploy-pipelines-on-git-automated)
  * [Deploy pipelines without version control](#deploy-pipelines-without-version-control)
  * [Create tekton webhook](#create-a-tekton-webhook)
  * [Package pipelines](#package-pipelines)
  
# Introduction
This repository includes 3 directories, `experimental`(pipelines that are not production-ready and are considered,
proof of concept),`incubator`(pipelines that are not production-ready and require further development to satisfy the stable criteria.) 
and `stable`(pipelines that are production ready).

This repository also contains multiple pipelines such as [artifactory-package-release-update](pipelines/experimental/artifactory-package-release-update), 
[git-package-release-update](./pipelines/experimental/git-package-release-update) and [mcm-pipelines](pipelines/incubator/mcm-pipelines).
You can view all [/pipelines/](./pipelines/incubator). The repository also contains a [./run.sh](./run.sh) script file which helps automate the process of deploying your pipelines on git.

There are multiple approaches on packaging and releasing your pipelines. Both the `artifactory-package-release-update` & `git-package-release-update` pipelines do the same thing, package, manage
and deploy your custom pipelines, except in different environments. For example, the `artifactory-package-release-update` pipeline, packages your
 pipelines and deploys them onto Artifactory, where as the `git-package-release-update` are deployed as git releases.

The `mcm-pipelines` contains the tasks of building, testing, pushing an image and a healthcheck of a nodejs application. It also
does a `sonar-scan` for code coverage.

# Pre-requisites
* Install the following CLI's on your laptop/workstation:

    + [`docker cli`](https://docs.docker.com/docker-for-mac/install/)
    + [`git cli`](https://git-scm.com/downloads)
    + [`oc cli`](https://docs.openshift.com/container-platform/4.3/welcome/index.html)
    + [`Openshift 4.3.5 with CloudPak for Apps`](https://www.ibm.com/cloud/cloud-pak-for-applications)
    + [`tekton cli`](https://github.com/tektoncd/cli)
    
# Deploy pipelines on Artifactory
### Pre-reqs
You need to deploy [Artifactory](https://github.com/ibm-cloud-architecture/gse-devops/tree/master/cloudpak-for-integration-tekton-pipelines#artifactory) on your openshift cluster

You need to generate an [API Key](https://www.jfrog.com/confluence/display/JFROG/User+Profile). Then you need to go to
[artifactory-config.yaml](configmaps/artifactory-config.yaml) and update the `artifactory_key`. Once done, run the following
commands:

```bash
oc project kabanero
oc apply -f artifactory-config.yaml
```

Then go to [pipelines](pipelines) make any modifications you want to do to any of the pipelines, or include your own.
If you do include your pipelines, use the [skeleton](pipelines/skeleton) to add your modified pipelines, tasks,
bindings, and templates. Go to section [Create tekton webhook](#create-a-tekton-webhook) to create your webhook.
Once you are done with that go to your forked repository and make a change and your tekton dashboard should create a 
new pipeline run as shown below:

[artifactory-package-release-update-pl-rn.png](img/artifactory-package-release-update-pl-rn.png)

You could also manually trigger your pipelines
![](gifs/artifactory-package-release-update-pl-rn.gif)

Where the `git-source` is defined as the pipeline resource with key [url] and value [github repo url] 

# Deploy pipelines on Git (Manually)
You will first need to package your pipelines. To do that go to the [package-pipelines](#package-pipelines)
After you are done with that step you will notice a new file named `default-kabanero-pipelines.tar.gz` under
`ci/assets` which includes your pipelines along with their corresponding checksum values. You will use this file to upload
as an asset on github.

But first, create a new repository i.e named `pipeline-server` on github and follow the steps as shown on the gif.
![](gifs/create-release-git.gif)


# Deploy pipelines on Git (Automated)
### Pre-reqs
You need to create a github 
[token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line)
and need to create a `.gitconfig` file such as:
    
```bash
~/Documents/devops-demo-kabanero-pipelines/ cat ~/.gitconfig

[user]
      name = firstname.lastname
      email = your-github-email@email.com
[github]
      token = your-token
```
    

You need to fork this repo and clone via https.
    
```bash
git clone https://github.com/ibm-cloud-architecture/devops-demo-kabanero-pipelines 
cd devops-demo-kabanero-pipelines
```
You need another repository to host your pipelines. i.e [pipelines-server](https://github.com/oiricaud/pipeline-server/releases) to create git-releases.
  
``` bash
mkdir pipeline-server
cd pipeline-server
git init 
cat >> README.md
    Hello this is my pipeline-server repo press (ctrl+d to save)
git add README.md
git commit -m "added README.md"
git push
```

Now is the time to make any changes you wish to make, or you can use the custom pipelines we have provided for you.


[![asciicast](https://asciinema.org/a/315675.svg)](https://asciinema.org/a/315675)

# Create a tekton webhook 
### Pre-reqs
You need to create an access token on the tekton dashboard or cli in the kabanero namespace.
Earlier you created a github token on the github dashboard. You will need to get that token or generate another one and 
paste it below.
![](gifs/access-token.gif)

Webhook Settings:

        Name: devops-demo-kabanero-pipelines
        Repistory-url: your forked repo url goes here
        Access Token: Token you generated previously 

Target Pipeline Settings
        
        Namespace: kabanero
        Pipeline: Choose artifactory-package-release-update-pl or git-package-release-update-pl
        Service Account: Pipeline
        Docker Registry: us.icr.io/project-name or docker.hub.io/projectname
        

# Package pipelines
To package your pipelines you must run the `run.sh` script as shown below: 
Enter `1` to set up your environment, containerize your pipelines and release them to a registry. 
Ensure to update the variables (optional) in [env.sh](ci/env.sh) with your corresponding registry values.

``` bash
# Publish images to image registry
# export IMAGE_REGISTRY_PUBLISH=false

# Credentials for publishing images:
# export IMAGE_REGISTRY=your-image-registry
# export IMAGE_REGISTRY_USERNAME=your-image-registry-username
# export IMAGE_REGISTRY_PASSWORD=your-image-password

# Organization for images
# export IMAGE_REGISTRY_ORG=your-org-name

# Name of pipelines-index image (ci/package.sh)
# export INDEX_IMAGE=pipelines-index

# Version or snapshot identifier for pipelines-index (ci/package.sh)
# export INDEX_VERSION=SNAPSHOT
```

``` bash
    > ./run.sh
    ===========================================================================
    
    ======================== AUTOMATOR SCRIPT =================================
    
    ===========================================================================
    
    Do you want to
        1) Set up environment, containerzied pipelines and release them to a registry?
        2) Add, commit and push your latest changes to github?
        3) Create a git release for your pipelines?
        4) Upload an asset to a git release version?
        5) Update the Kabanero CR custom resource with a release?
        6) Add a stable pipeline release version to the Kabanero custom resource?
        enter a number > 1
    **************************************************************************
    
    **************** BEGIN SETTING UP ENV, PACKAGE AND RELEASE ***************
    
    **************************************************************************
    
    /Users/Oscar.Ricaud@ibm.com/Documents/gse-devops/github.com/oiricaud-devops-demo-kabanero-pipelines
    Asset name: mcm-pipelines/tasks/igc-nodejs-test.yaml
    Asset name: mcm-pipelines/tasks/nodejs-build-push-task.yaml
    Asset name: mcm-pipelines/tasks/nodejs-image-scan-task.yaml
    Asset name: mcm-pipelines/tasks/gitops.yaml
    Asset name: mcm-pipelines/tasks/health-check-task.yaml
    Asset name: mcm-pipelines/pipelines/nodejs-mcm-pl.yaml
    Asset name: mcm-pipelines/templates/nodejs-mcm-pl-template.yaml
    Asset name: mcm-pipelines/bindings/nodejs-mcm-pl-push-binding.yaml
    Asset name: mcm-pipelines/bindings/nodejs-mcm-pl-pullrequest-binding.yaml
    Asset name: manifest.yaml
    --- Created kabanero-pipelines.tar.gz
    Failed building image
    IMAGE_REGISTRY_PUBLISH=false; Skipping push of docker.io/yellocabins/pipelines-index
    IMAGE_REGISTRY_PUBLISH=false; Skipping push of docker.io/yellocabins/pipelines-index:SNAPSHOT
    IMAGE_REGISTRY_PUBLISH=false; Skipping push of docker.io/yellocabins/pipelines-index
    IMAGE_REGISTRY_PUBLISH=false; Skipping push of docker.io/yellocabins/pipelines-index:SNAPSHOT
   
```

# Deploy pipelines without Version Control 
You can but not recommended non-version control your pipelines by running the following command

``` bash
oc apply --recursive --filename pipelines/{pick expiermental, incubator or stable}
```


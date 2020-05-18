# Introduction
This repository contains multiple pipelines such as `artifactory-package-release-update`, `git-package-release-update` and
`mcm-pipelines`. You can view all the pipelines at `/pipelines/incubator`. The repository also contains a `./run.sh` script file which helps automate the process of deploying your pipelines on git.

There are multiple approaches on packaging and releasing your pipelines. Both the `artifactory-package-release-update` & `git-package-release-update` pipelines do the same thing, package, manage
and deploy your custom pipelines, except in different environments. For example, the `artifactory-package-release-update` pipeline, packages your
 pipelines and deploys them onto Artifactory, where as the `git-package-release-update` are deployed as git releases.

The `mcm-pipelines` contains the tasks of building, testing, pushing an image and a healthcheck of a nodejs application. It also
does a `sonar-scan` for code coverage.

# Requirements
Openshift ICP4A (Cloudpak for Apps) or a local instance of minikube with Kabanero 0.6.0 installed
An Artifactory account

 
# Deploy pipelines via Artifactory

# Deploy pipelines via Git Releases (Manually)

# Deploy pipelines via Git Releases (Automated)
### Pre-reqs
You need to create a github [token](https://help.github.com/en/github/authenticating-to-github/creating-a-personal-access-token-for-the-command-line).
    
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


You need to create a webhook

[![asciicast](https://asciinema.org/a/315675.svg)](https://asciinema.org/a/315675)

# Deploy pipelines manually 


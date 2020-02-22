---
layout: post
title:  "Jenkins Home Lab: Part 4 - Setting up Linux Agents with Docker"
date:   2020-02-20 13:29:13 +1100
tags: [jenkins, ci, homelab, sysadmin, windows]
comments: true
ogimage: "/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/jenkins-p4-ogimage.png"
description: "Configuring Jenkins to use Docker for on-demand agents"
disabled: false
---

Today we will setup Linux on-demand agents through Docker. First step, let's install Docker.

<!--more-->

## Articles in this guide

- [Part 1 - Setting up the Master](/2019/12/27/JenkinsHomeLab-P1-MasterSetup.html)
- [Part 2 - Setting up Linux Agents on Ubuntu and Raspberry Pis](/2019/12/27/JenkinsHomeLab-P2-LinuxAgents.html)
- [Part 3 - Setting up Windows Agents (this article)](/2019/12/30/JenkinsHomeLab-P3-WindowsAgents.html)
- [Part 4 - Setting up Docker for on-demand linux agent creation](/2020/02/20/JenkinsHomeLab-P4-LinuxDockerAgents.html)
- Part 5 (Coming Soon) - Setting up Docker for on-demand windows agent creation

## Install Docker

There are 2 steps to installing Docker. Installing the Docker service, and then opening the HTTP API port.

### Raspberry Pi

Further details [are available here](https://dev.to/rohansawant/installing-docker-and-docker-compose-on-the-raspberry-pi-in-5-simple-steps-3mgl). We just need to run the following commands:

```bash
curl -sSL https://get.docker.com | sh
sudo usermod -aG docker pi
```

> <span class="badge badge-danger">Security Note</span> Adding the pi user to the docker group allows the pi user to control docker containers without using sudo. This might not always be desired as it grants some root privileges. More info here: [More info available in the Docker documentation.](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface)

### Ubuntu
```bash
sudo apt-get install docker.io
sudo usermod -aG docker YOURUSER
```

> <span class="badge badge-danger">Security Note</span> Adding the specified user to the docker group allows the user to control docker containers without using sudo. This might not always be desired as it grants some root privileges. [More info available in the Docker documentation.](https://docs.docker.com/engine/security/security/#docker-daemon-attack-surface)

### Open HTTP API port

The easiest way to do this is to create an override file for systemd to add a new parameter for the docker daemon. https://success.docker.com/article/how-do-i-enable-the-remote-api-for-dockerd

```bash
# Create the directory
sudo mkdir /etc/systemd/system/docker.service.d
# Create and open a new file for the options
sudo pico /etc/systemd/system/docker.service.d/startup_options.conf
```

Copy and paste the following config into the new file

```INI
# /etc/systemd/system/docker.service.d/override.conf
[Service]
ExecStart=
ExecStart=/usr/bin/dockerd -H fd:// -H tcp://0.0.0.0:2375
```

Save the file, and then run the following commands

```bash
sudo systemctl daemon-reload
sudo systemctl restart docker.service
```

You can verify this is working by navigating to the appropriate URL in your browser which will display some version information in JSON format.

```html
http://HOSTNAME:2375/version
```

> <span class="badge badge-danger">Security Note</span> In a production environment I’d recommend using TLS and adding additional security to secure your environment. In this case your port would also become 2376. https://docs.docker.com/engine/security/https/

## Fork & modify SSH Slave Docker image

Now that we have a docker server configured, let's create a container image that can be used by Jenkins. Jenkins already has an example docker container which we’ll base our image off. I don’t use this one as it won’t work on Raspberry Pi docker services and I prefer an image based off Ubuntu for my other images.

Jenkins will connect to this container via SSH, so it needs to inject an SSH key into the image. [The repository here contains an example of how to do this. This is what we'll fork.](https://github.com/jenkinsci/docker-ssh-slave)

The changes I made to this are minimal, and [can be seen in this commit](https://github.com/boristsr/docker-ssh-slave/commit/c678cca0b624f1e062f1f64237fa1ca0b8f6dad1).

I changed the base image to Ubuntu 18.04 for x86 images, and I included a step to install the default java runtime environment.

The key part of the provided example from [jenkinsci](https://github.com/jenkinsci/) is the script [setup-sshd](https://github.com/jenkinsci/docker-ssh-slave/blob/master/setup-sshd) which takes an environment variable, JENKINS_SLAVE_SSH_PUBKEY, and inserts it into the authorized_keys file before starting the SSH daemon. This allows Jenkins to connect to this docker container via the specified SSH key.

> <span class="badge badge-danger">Security Note</span> I haven’t been able to find a consistent source for up to date docker container images on Raspberry Pi. The [Hypriot](https://hub.docker.com/u/hypriot) ones seem to be quite popular though. These should be fine for a home lab, but I’d recommend sticking with x86 images in many circumstances as they are updated more frequently.

## Build & Push Image

For this step you need to log in to your Docker Hub account which will host your image.

```bash
docker login --username=yourhubusername --email=youremail@company.com
```

The repository has a makefile which I recommend you update, but for now we’ll just build and push the image manually.

From the directory where the Dockerfile is located run the following commands.

```bash
docker build -t YOURDOCKERUSERNAME/jenkins-ssh-slave:latest .
docker push YOURDOCKERUSERNAME/jenkins-ssh-slave:latest
```

> <span class="badge badge-danger">Security Note</span> It’s not critical for a home lab but you should update the Makefile and setup a job in Jenkins or via DockerHub to automatically build and push this image so it remains up to date.

## Configure Jenkins

All that’s left now is to get Jenkins talking to this new Docker host, and setup how to use the newly created image.

### Install Docker plugin

Navigate to Manage Jenkins -> Manage Plugins.

Click on the Available tab and search for “Docker”
There are numerous plugins that will show up, we want the one that has the description “This plugin integrates Jenkins with Docker” and is linked to https://plugins.jenkins.io/docker-plugin/

Tick it, and click Install without Restart, on the next page press “Restart Jenkins when installation is complete and no jobs are running” to ensure that everything is ready to go.

Once it is installed we can configure it to point to the docker host.

### Setup A Docker Cloud

Navigate to Manage Jenkins -> Configure System.

Scroll right to the bottom to find the new section Cloud.

Click Add a new cloud, and select docker.

Give it a name for your reference, and enter the following URI, changing your hostname

```html
tcp://DOCKERHOST:2375
```

> <span class="badge badge-danger">Security Note</span> Again, in production I would look into setting up TLS and authentication for users. Make sure to set your server credentials here in this case.

### Setup Docker Image

Now the docker host has been setup, click Docker Agent templates, and we’ll configure the docker image that was just created. Click Add Docker Template.

Things to configure here:
- **Labels:** This is the same as normal agent templates, so add a label that will allow us to target builds against this template. In my case that’s “docker-jenkins-linux
- **Name:** friendly name for your reference
- **Docker Image:** a reference to the docker image. If using DockerHub then a short reference is enough, however you can use full URLs if hosting elsewhere like GitHub.
- **Remote File System Root:** /home/jenkins - this is where jobs will store their data while performing the job
- **Connect Method:** Connect with SSH
> <span class="badge badge-warning">Note</span> If you don’t have a key set already generated, generate one and add it to jenkins as described in the Linux Agent article here. Make sure to copy the public key as we’ll use it shortly. TODO
- **SSH Key**: Use configured SSH Credentials
- **SSH Credentials:** Choose the credentials that match the public key we’ll set soon
- **Host Key Verification Strategy:** Non verifying Verification Strategy
- **Pull Strategy:** Pull once and update latest will keep your image up to date, while not wasting bandwidth

Now the top level options are set, expand the Container settings section under Docker Image.
Under Environment, you want to add a line like this:

```INI
JENKINS_SLAVE_SSH_PUBKEY=ssh-rsa YOUR SSH PUBLIC KEY
```

This sets an environment variable that the script discussed above will insert into the authorized_hosts file.

> <span class="badge badge-warning">Note</span> If you are using the original jenkins image, you will need to set the JavaPath option under Connect Method->Advanced to point to the appropriate java path, as it’s not in the path for the jenkins user.

That should be enough to set. You can tweak these as you see fit, and for future images.

### Setup Test Job

Now we’ll set up a new job to test the new image. On the Jenkins main page click New Item.

Enter a name for this job, and choose Freestyle project and click next.

Tick Restrict where this project can be run, and then enter the label that you configured for your Docker template.

Under Build, click Add build step and choose Execute Shell.

Enter the following code:

```bash
cat /home/jenkins/.ssh/authorized_keys
uname -a
```

This will print out the authorized_keys and show that the public key we specified was entered there, and also some basic system information.

Click Save.

On the main page of Jenkins, click the Run Job icon next to our new job.

If all goes well you’ll see the new agent start up. It may briefly show as offline as it initializes, and then it will complete the job rather quickly.

Click on the job name, and then click on a build under Build History to see information about it. Clicking Console Output will show the information that we expected to print out.

## Next Steps

Once you have a base docker image you are happy with, it should be fairly easy to create a new docker image that uses your base image and installs any dependencies required for specific projects.

In the next article in this series I’ll be discussing documenting setting up a Windows docker service, but this will be in a few weeks.

As an exercise in the meantime try creating a job that automatically builds and pushes your image to DockerHub.

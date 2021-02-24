---
layout: post
title:  "Jenkins Home Lab: Part 4 - On-Demand Linux Agents with Docker"
date:   2020-02-21 13:29:13 +1100
tags: [jenkins, ci, homelab, sysadmin, windows]
comments: true
image: "/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/jenkins-p4-ogimage.png"
summary: "Configuring Jenkins to use Docker for on-demand agents"
permalink: /2020/02/21/JenkinsHomeLab-P4-LinuxDockerAgents.html
categories: blog
---

Today we will setup on-demand linux agents through Docker. First step, let's install Docker.

<!--more-->

## Articles in this guide

- [Part 1 - Setting up the Master]({{ site.url }}{% post_url blog/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup %})
- [Part 2 - Setting up Linux Agents on Ubuntu and Raspberry Pis]({{ site.url }}{% post_url blog/jenkins-home-lab/2019-12-28-JenkinsHomeLab-P2-LinuxAgents %})
- [Part 3 - Setting up Windows Agents]({{ site.url }}{% post_url blog/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents %})
- [Part 4 - Setting up Docker for on-demand linux agent creation (this article)]({{ site.url }}{% post_url blog/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents %})
- Part 5 (Coming Soon) - Setting up Docker for on-demand windows agent creation

## A quick note on updates to this article

Since this article was published the Jenkins community has begun the process of updating repo names and documentation to prefer agent over slave. I've tried to keep this article up to date with new URLs, however there may be some leftover references.

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

The easiest way to do this is to create an override file for systemd to add a new parameter for the Docker daemon. [More details on this are here](https://success.docker.com/article/how-do-i-enable-the-remote-api-for-dockerd) but the relevant details are below.


On the new system that is hosting Docker open a console and perform the following.

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

> <span class="badge badge-danger">Security Note</span> In a production environment I’d recommend using TLS and adding additional security to secure your environment. In this case your port would also become 2376. [This is discussed in detail here.](https://docs.docker.com/engine/security/https/)

## Fork & Modify SSH Agent Docker image

Now that we have a Docker server configured, let's create a container image that can be used by Jenkins. Jenkins already has an example docker container which we’ll base our image off. I don’t use this one as it won’t work on Raspberry Pi Docker services and I prefer an image based off Ubuntu for my other images.

Jenkins will connect to this container via SSH, so it needs to inject an SSH key into the image. [The repository here contains an example of how to do this. This is what we'll fork.](https://github.com/jenkinsci/docker-ssh-agent)

The changes I made to this are minimal, and [can be seen in this commit](https://github.com/boristsr/docker-ssh-slave/commit/c678cca0b624f1e062f1f64237fa1ca0b8f6dad1).

I changed the base image to Ubuntu 18.04 for x86 images, and I included a step to install the default java runtime environment.

The key part of the provided example from [jenkinsci](https://github.com/jenkinsci/) is the script [setup-sshd](https://github.com/jenkinsci/docker-ssh-agent/blob/master/setup-sshd) which takes an environment variable, JENKINS_AGENT_SSH_PUBKEY (previous versions called this JENKINS_SLAVE_SSH_PUBKEY if you forked from an earlier version), and inserts it into the authorized_keys file before starting the SSH daemon. This allows Jenkins to connect to this Docker container via the specified SSH key.

> <span class="badge badge-danger">Security Note</span> I haven’t been able to find a consistent source for up to date Docker container images on Raspberry Pi. The [Hypriot](https://hub.docker.com/u/hypriot) ones seem to be quite popular though. These should be fine for a home lab, but I’d recommend sticking with x86 images in many circumstances as they are updated more frequently.

## Build & Push Image

For this step you need to log in to your Docker Hub account which will host your image.

```bash
docker login --username=yourhubusername --email=youremail@company.com
```

The repository has a makefile which I recommend you update, but for now we’ll just build and push the image manually.

From the directory where the Dockerfile is located run the following commands.

```bash
docker build -t YOURDOCKERUSERNAME/jenkins-ssh-agent:latest .
docker push YOURDOCKERUSERNAME/jenkins-ssh-agent:latest
```

> <span class="badge badge-danger">Security Note</span> It’s not critical for a home lab but you should update the Makefile and setup a job in Jenkins or via DockerHub to automatically build and push this image so it remains up to date.

## Configure Jenkins

All that’s left now is to get Jenkins talking to this new Docker host, and setup how to use the newly created image.

### Install Docker plugin

Navigate to Manage Jenkins -> Manage Plugins.

Click on the Available tab and search for “Docker”

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/01-01-SearchPlugins.jpg){: .enable-lightbox}

There are numerous plugins that will show up, we want the one that has the description “This plugin integrates Jenkins with Docker” and is linked to [https://plugins.jenkins.io/docker-plugin/](https://plugins.jenkins.io/docker-plugin/)

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/01-02-CorrectDockerPlugin.jpg){: .enable-lightbox}

Tick it, and click Install without Restart. On the next page press “Restart Jenkins when installation is complete and no jobs are running” to ensure that everything is ready to go.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/01-03-InstallingPlugins.jpg){: .enable-lightbox}

Once it is installed we can configure it to point to the Docker host.

### Setup A Docker Cloud

Navigate to Manage Jenkins -> Configure System.

Scroll right to the bottom to find the new section Cloud.

Click Add a new cloud, and select Docker. Click Docker Cloud details to expand host information.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/02-01-DockerCloudDetails.jpg){: .enable-lightbox}

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/02-02-DockerCloudDetailsFilled.jpg){: .enable-lightbox}

Give it a name for your reference, and enter the following URI, changing your hostname.

```html
tcp://DOCKERHOST:2375
```

> <span class="badge badge-danger">Security Note</span> Again, in production I would look into setting up TLS and authentication for users. Make sure to set your server credentials here in this case.

### Setup Docker Image

Now the Docker host has been setup, click Docker Agent templates, and we’ll configure the Docker image that was just created. Click Add Docker Template.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/03-01-DockerAgentTemplates.jpg){: .enable-lightbox}

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/03-02-AddDockerTemplate.jpg){: .enable-lightbox}

Things to configure here:

- **Labels:** This is the same as normal agent templates, so add a label that will allow us to target builds against this template. In my case that’s “docker-jenkins-linux"
- **Enabled:** By default new images are disabled, so make sure to check this box.
- **Name:** friendly name for your reference
- **Docker Image:** a reference to the Docker image. If using DockerHub then a short reference is enough, however you can use full URLs if hosting elsewhere like GitHub.
- **Remote File System Root:** /home/jenkins - this is where jobs will store their data while performing the job
- **Connect Method:** Connect with SSH
> <span class="badge badge-warning">Note</span> If you don’t have a key set already generated, generate one and add it to jenkins as described in the [Linux Agent article here](/2019/12/27/JenkinsHomeLab-P2-LinuxAgents.html#generate-an-ssh-key). Make sure to copy the public key as we’ll use it shortly.
- **SSH Key**: Use configured SSH Credentials
- **SSH Credentials:** Choose the credentials that match the public key we’ll set soon
- **Host Key Verification Strategy:** Non verifying Verification Strategy
- **Pull Strategy:** Pull once and update latest will keep your image up to date, while not wasting bandwidth

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/03-03-TopLevelSettings.jpg){: .enable-lightbox}

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/03-04-SSHSettings.jpg){: .enable-lightbox}

Now the top level options are set, expand the Container settings section under Docker Image.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/03-05-ContainerSettings.jpg){: .enable-lightbox}

Under Environment, you want to add a line like this:

```INI
JENKINS_AGENT_SSH_PUBKEY=ssh-rsa YOUR SSH PUBLIC KEY
```

or if you have an older image or version of setup-sshd script

```INI
JENKINS_SLAVE_SSH_PUBKEY=ssh-rsa YOUR SSH PUBLIC KEY
```

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/03-06-PublicKey.jpg){: .enable-lightbox}

This sets an environment variable that the script discussed above will insert into the authorized_hosts file by the setup-sshd script in the Docker image discussed earlier.

> <span class="badge badge-warning">Note</span> If you are using the original jenkins image, you will need to set the JavaPath option under Connect Method->Advanced to point to the appropriate java path, as it’s not in the path for the jenkins user.

Also make sure to check the option for **Remove Volumes**. I enable this to reclaim more disk space after a job has completed. Your use case might want to preserve these.

That should be enough to configure our first image. You can tweak these as you see fit for future images.

### Setup Test Job

Now we’ll set up a new job to test the new image. On the Jenkins main page click New Item.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-01-NewItem.jpg){: .enable-lightbox}

Enter a name for this job, and choose Freestyle project and click next.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-02-FreestyleProjectName.jpg){: .enable-lightbox}

Tick Restrict where this project can be run, and then enter the label that you configured for your Docker template.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-03-RestrictJobs.jpg){: .enable-lightbox}

Under Build, click Add build step and choose Execute Shell.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-04-ExecuteShellStep.jpg){: .enable-lightbox}

Enter the following code:

```bash
cat /home/jenkins/.ssh/authorized_keys
uname -a
```

This will print out the authorized_keys and show that the public key we specified was entered there, and also some basic system information.

Click Save.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-05-AddedCodeSave.jpg){: .enable-lightbox}

On the main page of Jenkins, click the Run Job icon next to our new job.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-06-RunJob.jpg){: .enable-lightbox}

If all goes well you’ll see the new agent start up. It may briefly show as offline as it initializes, and then it will complete the job rather quickly.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-07-OfflineAgent.jpg){: .enable-lightbox}

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-08-ExecutingJob.jpg){: .enable-lightbox}

Click on the job name, and then click on a build under Build History to see information about it. Clicking Console Output will show the information that we expected to print out.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-10-JobNumber.jpg){: .enable-lightbox}

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2020-02-21-JenkinsHomeLab-P4-LinuxDockerAgents/04-11-ConsoleOutput.jpg){: .enable-lightbox}

## Next Steps

Once you have a base Docker image you are happy with, it should be fairly easy to create a new Docker image that uses your base image and installs any dependencies required for specific projects.

In the next article in this series I’ll be discussing documenting setting up a Windows Docker service, but this will be in a few weeks.

As an exercise in the meantime try creating a job that automatically builds and pushes your image to DockerHub.

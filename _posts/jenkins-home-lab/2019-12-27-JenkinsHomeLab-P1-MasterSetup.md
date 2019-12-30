---
layout: post
title:  "Jenkins Home Lab: Part 1 - Setting up the Master"
date:   2019-12-27 13:29:13 +1100
tags: [jenkins, ci, HomeLab, sysadmin, docker, RaspberryPi, linux]
comments: true
ogimage: "/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/jenkins-p1-ogimage.png"
description: "A guide for building a Jenkins home lab. In this first part you'll learn how to configure a Jenkins master server."
---

Are you looking for a project this holidays? Did you get a Raspberry Pi for Christmas? Why not setup a home lab for CI/CD with Jenkins? Over the next week or so I’m going to output a series of tutorials aimed at setting up a comprehensive home lab environment for Jenkins. With this home lab you can turn any old or cheap computers into an environment to automate tasks for your side projects, sharpen your CI/CD skills, and prototype new project pipelines.

<!--more-->

## Overview

I embarked on creating my own home lab to automate tasks on a few side projects as well as a way of filling in some knowledge gaps of mine, specifically aiming to learn windows containers and [Docker](https://www.docker.com/) on ARM architectures, like a [Raspberry Pi](https://www.raspberrypi.org/). As a result this guide is going to cover many different options. I’ve aimed to keep it modular so you can pick how you want to run your master Jenkins server, and choose any or all of the different agents for your environment.

> <span class="badge badge-danger">Security Note</span> This guide is focused on a home lab environment so certain security principles will not be rigidly conformed to. I’ll make a note anytime a security assumption or choice is made that should be more carefully considered in a production environment.

## Articles in this guide

- [Part 1 - Setting up the Master (this article)](/2019/12/27/JenkinsHomeLab-P1-MasterSetup.html)
- [Part 2 - Setting up Linux Agents on Ubuntu and Raspberry Pis](/2019/12/27/JenkinsHomeLab-P2-LinuxAgents.html)
- [Part 3 - Setting up Windows Agents](/2019/12/30/JenkinsHomeLab-P3-WindowsAgents.html)
- Part 4 (Coming Soon) - Setting up Docker for on-demand linux agent creation
- Part 5 (Coming Soon) - Setting up Docker for on-demand windows agent creation
- Part 6 (Coming Soon) - Jenkins Pipeline, Jenkinsfiles & hints on designing jobs.
## Why Jenkins?

There are plenty of CI/CD tools around. Some paid, some free, some cloud hosted, some self hosted. All of these tools have strengths and weaknesses, but in general you can accomplish the same tasks in all of them. I’ve chosen Jenkins for this since it’s free, open source, and incredibly flexible.

Jenkins is written in Java and runs in many environments. It is focused on running user defined tasks and pipelines. This means you can mix architectures and operating systems freely in this setup, all that matters is that your jobs are compatible with an environment available on an agent or slave that you’ve configured.

## Jenkins Master requirements & setup options

We’ll be configuring the Jenkins master purely as a tool for coordinating agents, and disabling local execution of jobs. This means that we don’t need a particularly powerful machine to run this on, however this is where job artifacts (built projects) will be stored, so make sure you have enough storage for your intended projects.

I won't be showing you how to install a JDK, maven and other java related build tools. You can add the build tools and prerequisites to fit your projects and needs later. Ideally once we've setup Docker agents your projects will define all prerequisites and dependencies which will be built into the Docker images or installed during the build process.

## Where would you like to setup your Jenkins Master?

Click an option below to jump straight to the relevant instructions.

- [Raspberry Pi](#installing-jenkins-on-ubuntu--raspbian)
- [Ubuntu](#installing-jenkins-on-ubuntu--raspbian)
- [Docker](#installing-with-docker)
- [Synology NAS](#running-the-jenkins-docker-image-from-a-synology-nas)

## Installing Jenkins on Ubuntu & Raspbian

Installing Jenkins is the same process on Ubuntu and [Raspbian](https://raspberrytips.com/install-jenkins-raspberry-pi/), and likely all debian based distributions.

First we add the Jenkins repository to apt, including the associated key.

```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
```

Update the repository

```bash
sudo apt update
```

Install the default java runtime and Jenkins

```bash
sudo apt install default-jre jenkins -y
```

Now we need to get the initial password for Jenkins, save the output of this for later.

```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

You can now logout from the terminal on the Raspberry Pi and move on to [configuring Jenkins](#configuring-the-jenkins-master).

## Installing with Docker

Docker is probably the simplest and lightest way to host a Jenkins master instance as it’s quite literally 2 commands, and upgrading is as simple as recreating the container with a newer image while pointing to the same volume for the jenkins_home directory.

### Installing Docker - Quickstart

I won’t cover this extensively, but these are the commands you need to get started quickly. For further configuration information see [here for install instructions](https://docs.docker.com/install/) and [here for post-install configuration](https://docs.docker.com/install/linux/linux-postinstall/).

#### Installing Docker on Ubuntu

Running the below 3 commands will install Docker and set it to automatically start on system boot. Further details on this are [available here](https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04).

```bash
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

### Running Jenkins Docker Image from Command Line

Running Jenkins in Docker is [really simple and can be accomplished in 2 commands](https://batmat.net/2018/09/07/how-to-run-and-upgrade-jenkins-using-the-official-docker-image/).

The image we want to use is [jenkins/jenkins:lts](https://jenkins.io/blog/2018/12/10/the-official-Docker-image/). Targeting the [Long Term Support release](https://jenkins.io/download/lts/) means this release is likely to be more stable, and will be patched for a longer period.

Next up, we can create a place to store persistent data. This makes backup and upgrades easier.  The persistent volume is all you need to backup, and [upgrading is as simple as recreating the container with a newer image, pointing it to the same persistent volume for jenkins_home](https://batmat.net/2018/09/07/how-to-run-and-upgrade-jenkins-using-the-official-docker-image/). For specific upgrade notes you can always [check the upgrade guide](https://jenkins.io/doc/upgrade-guide/).

Command to Create volume

```bash
docker volume create jenkins-master-home
```

Argument to use volume

```bash
-v jenkins-master-home:/var/jenkins_home
```

Next, 2 ports need to be exposed to allow access to the webpage and communication with agents/slaves. This is accomplished with these arguments:

> <span class="badge badge-danger">Security Note</span> This exposes these ports on the host system so other systems can connect to Jenkins. To be clear these are not being exposed to the internet and in general I'd avoid exposing these to the internet.

```bash
-p 8080:8080 -p 50000:50000
```

The full command lines are:

```bash
docker volume create jenkins-master-home
docker run --name jenkins-master \
           --detach \
           -v jenkins-master-home:/var/jenkins_home \
           -p 8080:8080 \
           -p 50000:50000 \
           jenkins/jenkins:lts
```

You need to get the initial admin password, run this command and save the output for later.

```bash
docker exec jenkins-master bash -c 'cat /var/jenkins_home/secrets/initialAdminPassword'
```

To stop the container run

```bash
docker container stop jenkins-master
```

To start a docker container after the host has rebooted or after it’s stopped run:

```bash
docker container start jenkins-master
```

Now we have a working container, [you can move onto initial configuration.](#configuring-the-jenkins-master)

### Running the Jenkins Docker image from a Synology NAS

At home I run a [Synology DS918+](https://www.synology.com/en-global/products/DS918+), so being able to host the docker container on this is really convenient. It’s always on, reliable, and already has backup tasks configured, so it’s a perfect place to host it. You can also install Jenkins directly from the Synology Package Center, however running it in Docker will keep it self contained and give you more control over which version you install.

Configuration is mostly straight forward with the exception of a small permission change required on the jenkins_home directory. Unfortunately the synology docker UI doesn’t support docker volumes, and instead uses bind-mounts. This is not ideal, as it usually has some complications around permissions as seen here, but it’s safe and workable.

> <span class="badge badge-danger">Security Note</span> Ideally you’d create a jenkins user and group with matching UIDs for a more permanent solution. It’s clearer to manage than raw UIDs.

Create a directory somewhere on your NAS, for me it’s in a Shared Folder dedicated to Docker.

SSH into your NAS

```bash
ssh user@nashostname
```

Change permissions on the folder to be owned by user and group 1000

```bash
sudo chown -R 1000:1000 /volume1/docker/JenkinsMaster/dataFolder/var/jenkins_home
```

Exit the SSH session. We are now ready to setup the container on the Synology NAS.

Search the registry for the jenkins/jenkins image
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.01-synology-jenkins-image-repository.jpg){: .enable-lightbox}

Download the Jenkins image with tag LTS
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.02-synology-jenkins-image-tag.jpg){: .enable-lightbox}

Create the container by double clicking the image
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.03-synology-jenkins-create-container-from-image.jpg){: .enable-lightbox}

Enter a name for the container and then enter Advanced Settings
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.04-synology-jenkins-create-container-basic.jpg){: .enable-lightbox}

Expose the ports
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.05-synology-jenkins-expose-ports.jpg){: .enable-lightbox}

Map the jenkins_home folder by clicking Add Folder and selecting the folder you created previously.
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.06-synology-jenkins-map-home-add-folder.jpg){: .enable-lightbox}
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.07-synology-jenkins-map-home-folder-selection.jpg){: .enable-lightbox}

Enter the mount path as

```bash
/var/jenkins_home
```

Apply the advanced settings and continue with container creation
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.08-synology-jenkins-create-summary.jpg){: .enable-lightbox}

Press apply and the container will start up.

To get the initial password we need to connect a second terminal to this instance and run a command. Click the new container and click details.
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.09-synology-jenkins-created.jpg){: .enable-lightbox}

Once in the running container details, click Terminal, and then Create. Click on the newly created terminal, labelled bash.

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/1.10-synology-jenkins-terminal.jpg){: .enable-lightbox}

Run the command

```bash
cat /var/jenkins_home/secrets/initialAdminPassword
```

Copy the output of this command, as this is the initial password we will need when logging into Jenkins.

Run the exit command to close this terminal

```bash
exit
```

You can now close the container window and [proceed to configuring Jenkins.](#configuring-the-jenkins-master)

## Configuring the Jenkins Master

You can now access jenkins at http://HOSTNAME-OR-IP:8080 in your browser.

### Initial Login

Enter the password that we captured from the file at /var/jenkins_home/secrets/initialAdminPassword after installing Jenkins.
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.01-jenkins-initial-login.jpg){: .enable-lightbox}

### Plugins

I recommend just installing the recommended plugins first up. You can always add or remove plugins later.
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.02-plugin-options.jpg){: .enable-lightbox}

This will take a while to download depending on your internet speed and system.

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.03-installing-plugins.jpg){: .enable-lightbox}

### Create Admin User

> <span class="badge badge-danger">Security Note</span> In a home lab generally you’ll only configure 1 or 2 users, however you should always follow the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege), especially since jobs will likely have access to credentials for other systems and services, and an error in code could have unintended effects. Appropriately planning access will allow you to create users that can run jobs but not access or modify credentials and jobs. Plan your access appropriately. [Read the Jenkins handbook section on Securing Jenkins here](https://jenkins.io/doc/book/system-administration/security/).

Enter the details for your main admin user.

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.04-creating-first-admin-user.jpg){: .enable-lightbox}

### Instance Configuration

Unless you are planning on renaming the host, or adding a custom DNS entry for this server then the default setting is probably ok.

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.05-instance-configuration.jpg){: .enable-lightbox}

### Wizard Finished

Congratulations, you now have a Jenkins master installed. We still should perform a few configuration tasks on this since we have a larger setup planned. I like to keep the master node as clean as possible so i don’t like running jobs on this instance, so lets go ahead and disable those.

### Disable jobs on this node

It is [best practice to not build on the master node](https://wiki.jenkins.io/display/JENKINS/Jenkins+Best+Practices). This is more secure and reduces long term issues including performance and conflicting dependencies. It's easier to wipe and recreate an agent than to fix or clean the master system.

In the left hand menu on the side enter Manage Jenkins, and then enter Configure System. This page can be slow to load, be patient.

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.06-manage-jenkins.jpg){: .enable-lightbox}

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.07-configure-system.jpg){: .enable-lightbox}

In here change “# of executors” to 0 and click Save. This is the number of jobs that can be run concurrently on the master node, not the number of agents that will eventually connect.
![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.08-change-num-executors.jpg){: .enable-lightbox}

Once this is applied the Build Executor Status box on the left will now be empty.

Before:

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.09-executors-before.jpg){: .enable-lightbox}

After:

![jenkins](/assets/posts/jenkins-home-lab/2019-12-27-JenkinsHomeLab-P1-MasterSetup/2.10-executors-after.jpg){: .enable-lightbox}

## What’s Next?

Now we have a configured Jenkins Master node we are ready to add some agents to perform some actual work for us which I’ll cover tomorrow. In the meantime, you may want to consider setting up email notifications.

Email notifications aren’t essential for a home lab, however I recommend spending some time setting them up as it’s nice to know when jobs fail. All the relevant settings are also under Manage Jenkins->Configure System. [Here are some instructions](https://www.360logica.com/blog/email-notification-in-jenkins/).

Tomorrow I’ll cover configuring linux SSH agents. This will involve setting up an SSH key, installing java, and configuring Jenkins to remotely start the agent. This is a good method to use for VMs, a Raspberry Pi and other bare metal linux systems.

Continue on with [Part 2 - Setting up Linux Agents on Ubuntu and Raspberry Pis](/2019/12/27/JenkinsHomeLab-P2-LinuxAgents.html)
---
layout: post
title:  "Jenkins Home Lab: Part 1 - Master Setup"
date:   2019-12-16 13:29:13 +1100
tags: [jenkins, ci, homelab, sysadmin, docker, raspberrypi, linux]
comments: true
ogimage: "/assets/posts/jenkins-home-lab/2019-12-17-JenkinsHomeLab-P1-MasterSetup/jenkins-p1-ogimage.png"
---

Over the next week or so I’m going to output a series of tutorials aimed at setting up a comprehensive home lab environment for Jenkins. With this home lab you can turn any old or cheap computers into an environment to automate tasks for your side projects, sharpen your CI/CD skills, and prototype new project pipelines.

<!--more-->

## Overview

I embarked on creating my own home lab to automate tasks on a few side projects as well as a way of filling in some knowledge gaps of mine, specifically aiming to learn windows containers and docker on arm architecture, like raspberry pis. As a result this guide is going to cover many different options. I’ve aimed to keep it modular so you can pick how you want to run your master jenkins server, and choose any or all of the different agents for your environment.

> <span class="badge badge-danger">Security Note</span> This guide is focused on a home lab environment so certain security principles will not be rigidly conformed to. I’ll make a note anytime a security assumption or choice is made that should be more carefully considered in a production environment.

## Why Jenkins?

There are plenty of CI/CD tools around. Some paid, some free, some cloud hosted, some self hosted. All of these tools have strengths and weaknesses, but in general you can accomplish the same tasks in all of them. I’ve chosen jenkins for this since it’s free, open source, and incredibly flexible.

Jenkins is written in Java and runs in many environments. It is focused on running user defined tasks and pipelines. This means you can mix architectures and operating systems freely in this setup, all that matters is that your jobs are compatible with an environment available on an agent or slave that you’ve configured.

## Jenkins Master requirements & setup options

We’ll be configuring the jenkins master purely as a tool for coordinating agents, and disabling local execution of jobs. This means that we don’t need a particularly powerful machine to run this on, however this is where job artifacts (built projects) will be stored, so make sure you have enough storage for your intended projects.

## Where would you like to setup your Jenkins Master?

Click an option below to jump straight to the relevant instructions.

- [Raspberry Pi](#installing-jenkins-on-ubuntu--raspbian)
- [Ubuntu](#installing-jenkins-on-ubuntu--raspbian)
- [Docker](#installing-with-docker)
- [Synology NAS](#running-the-jenkins-docker-image-from-a-synology-nas)

## Installing Jenkins on Ubuntu & Raspbian

Installing Jenkins is the same process on Ubuntu and [Raspbian](https://raspberrytips.com/install-jenkins-raspberry-pi/), and likely all debian based distributions.

First we add the jenkins repository to apt, including the associated key.

```bash
wget -q -O - https://pkg.jenkins.io/debian/jenkins.io.key | sudo apt-key add -
sudo sh -c 'echo deb https://pkg.jenkins.io/debian-stable binary/ > /etc/apt/sources.list.d/jenkins.list'
```

Update the repository
```bash
sudo apt update
```

Install the default java runtime and jenkins
```bash
sudo apt install default-jre jenkins -y
```

Now we need to get the initial password for jenkins, save the output of this for later.
```bash
sudo cat /var/lib/jenkins/secrets/initialAdminPassword
```

You can now logout from the terminal on the raspberry pi and we can proceed to configuring Jenkins.

## Installing with Docker

Docker is probably the simplest and lightest way to host a jenkins master instance as it’s quite literally 2 commands, and upgrading is as simple as recreating the container with a newer image while pointing to the same volume for the jenkins_home directory.

### Installing Docker - Quickstart

I won’t cover this extensively, but these are the commands you need to get started quickly. For further configuration information see [here for install instructions](https://docs.docker.com/install/) and [here for post-install configuration](https://docs.docker.com/install/linux/linux-postinstall/).

#### Installing Docker on Ubuntu

Running the below 3 commands will install docker and set it to automatically start on system boot. Further details on this are [available here](https://phoenixnap.com/kb/how-to-install-docker-on-ubuntu-18-04).

```bash
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
```

### Running Jenkins Docker Image from Command Line

Running jenkins in docker is [really simple and can be accomplished in 2 commands](https://batmat.net/2018/09/07/how-to-run-and-upgrade-jenkins-using-the-official-docker-image/).

The image we want to use is [jenkins/jenkins:lts](https://jenkins.io/blog/2018/12/10/the-official-Docker-image/). Targetting the [Long Term Support release](https://jenkins.io/download/lts/) means this release likely to be more stable, and will be patched for a longer period.

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
INSERTIMAGE

Download the jenkins image with tag LTS
INSERTIMAGE

Create the container by double clicking the image
INSERTIMAGE

Enter a name for the container and then enter Advanced Settings
INSERTIMAGE

Expose the ports
INSERTIMAGE

Map the jenkins_home folder by clicking Add Folder and selecting the folder you created previously.
INSERTIMAGE

Enter the mount path as

```bash
/var/jenkins_home
```

Apply the advanced settings and continue with container creation
OI Change image to reflect correct ports
INSERTIMAGE

Press apply and the container will start up.

To get the initial password we need to connect a second terminal to this instance and run a command. Click the new container and click details.
INSERTIMAGE
OI Modify image to not have bob the builder

Once in the running container details, click Terminal, and then Create
INSERTIMAGE

Click on the newly created terminal, labelled bash
INSERTIMAGE

Run the command

```bash
cat /var/jenkins_home/secrets/initialAdminPassword
```

Copy the output of this command, as this is the initial password we will need when logging into jenkins.

Run the exit command to close this terminal

```bash
exit
```

You can now close the container window and proceed to configuring jenkins

## Configuring Jenkins Master

You can now access jenkins at http://HOSTNAME-OR-IP:8080 in your browser.

### Initial Login

Enter the password that we captured after installing jenkins.

### Plugins

I recommend just installing the recommended plugins first up. You can always add or remove plugins later.
INSERTIMAGE

### Create Admin User

INSERTIMAGE

> <span class="badge badge-danger">Security Note</span> In a home lab generally you’ll only configure 1 or 2 users, however you should always follow the [principle of least privilege](https://en.wikipedia.org/wiki/Principle_of_least_privilege), especially since jobs will likely have access to credentials for other systems and services, and an error in code could have unintended effects. Appropriately planning access will allow you to create users that can run jobs but not access or modify credentials and jobs. Plan your access appropriately. [Read the Jenkins handbook section on Securing Jenkins here](https://jenkins.io/doc/book/system-administration/security/).

### Instance Configuration

Unless you are planning on renaming the host, or adding a custom DNS entry for this server then the default setting is probably ok.

### Wizard Finished

Congratulations, you now have a jenkins master installed. We still should perform a few configuration tasks on this since we have a larger setup planned. I like to keep the master node as clean as possible so i don’t like running jobs on this instance, so lets go ahead and disable those.

### Disable jobs on this node

It is [best practice to not build on the master node](https://wiki.jenkins.io/display/JENKINS/Jenkins+Best+Practices). This is more secure and reduces long term issues if any of your scripts or jobs install extra dependencies that may conflict. It's easier to wipe and recreate an agent than to fix or clean the master system.

In the left hand menu on the side enter Manage Jenkins, and then enter Configure System. This page can be slow to load, be patient.

In here change “# of executors” to 0 and click Save.

Once this is applied the Build Executor Status box on the left will now be empty.

## What’s Next?
Now we have a configured Jenkins Master node we are ready to add some agents to perform some actual work for us which I’ll cover tomorrow. In the meantime, you may want to consider setting up email notifications.

Email notifications aren’t essential for a home lab, however I recommend spending some time setting them up as it’s nice to know when jobs fail. All the relevant settings settings are also under Manage Jenkins->Configure System. [Here are some instructions](https://www.360logica.com/blog/email-notification-in-jenkins/).

Tomorrow I’ll cover configuring linux SSH agents. This will involve setting up an SSH key, installing java, and configuring Jenkins to remotely start the agent. This is a good method to use for VMs, raspberry pis and other bare metal linux systems. 

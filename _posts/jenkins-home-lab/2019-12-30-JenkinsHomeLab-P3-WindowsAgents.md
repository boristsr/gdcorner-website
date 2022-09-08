---
layout: post
title:  "Jenkins Home Lab: Part 3 - Setting up Windows Agents"
date:   2019-12-30 13:29:13 +1100
tags: [jenkins, ci, homelab, sysadmin, windows]
comments: true
image: "/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/jenkins-p3-ogimage.png"
description: "Configuring Windows agents for a Jenkins home lab."
permalink: /2019/12/30/JenkinsHomeLab-P3-WindowsAgents.html
categories: blog
series: jenkins_homelab_series
---

Today, since we already have a working setup of Jenkins, lets expand it to include windows agents.

<!--more-->

## UPDATE: Java Requirement Update with newer Jenkins versions

Jenkins has recently updated their Java requirements to 11+, and this guide has been updated to match. If you are experiencing problems after following this guide and you see errors like these:

```
java.nio.channels.ClosedChannelException
	at org.jenkinsci.remoting.protocol.impl.ChannelApplication
```

```
java.lang.UnsupportedClassVersionError: hudson/slaves/SlaveComputer$SlaveVersion has been compiled by a more recent version of the Java Runtime (class file version 55.0), this version of the Java Runtime only recognizes class file versions up to 52.0
```

If you see these errors you need to update Java to 11+ on your windows agent. [Instructions can be found at the end of this guide.](#troubleshooting-updating-java-runtime)

## Configuring Jenkins

There are a few things that need to be configured on the Jenkins master server, we'll get that out of the way first.

### Enable TCP ports for JNLP usage

This is likely already done if you are running the Docker image for the master server, but you should check anyway. This will enable the java client on windows to communicate with the master server.

Go to the home page and click on Manage Jenkins

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/1.01-manage-jenkins.jpg){: .enable-lightbox}

Click on Configure Global Security

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/1.02-global-security.jpg){: .enable-lightbox}

Scroll down to Agents and set the TCP port for inbound agents to 50000.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/1.03-tcp-port.jpg){: .enable-lightbox}

### Install the Powershell plugin

Powershell gives you significantly more flexibility in build steps. This plugin will add support for Powershell commands as a build step.

Go to the home page and click on Manage Jenkins

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/1.01-manage-jenkins.jpg){: .enable-lightbox}

Click on Manage Plugins

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/2.02-manage-plugins.jpg){: .enable-lightbox}

Click on Available and search for "Powershell". Tick this plugin and click install without restart.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/2.03-powershell-plugin.jpg){: .enable-lightbox}

### Create agent node

Go to the home page and click on Manage Jenkins

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/1.01-manage-jenkins.jpg){: .enable-lightbox}

Click on Manage nodes

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/3.02-manage-nodes.jpg){: .enable-lightbox}

Enter a name and choose Permanent Agent

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/3.03-create-agent.jpg){: .enable-lightbox}

Enter the following details:

- **Name**: Name of the node to be displayed in Jenkins
- **\# of executors**: how many jobs should be able to concurrently run on this agent, generally set this to the number of cores available.
- **Labels**: a list of labels associated with this node. This can be used to restrict jobs to this node or node type. I like to put in operating system and architecture.
- **Remote root directory**: C:\jenkins
- **Launch method**: Launch agent by connecting it to the master

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/3.04-agent-details.jpg){: .enable-lightbox}

After clicking on save you will be returned to a list of nodes. Click on the newly created node which will be offline.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/3.05-agent-list.jpg){: .enable-lightbox}

Depending on which master hosting method used you may be able to launch with Java webstart, but that won't allow you to install the service since it won't run with administrative priviledges. Instead we'll use the second connection method. For now copy the following as we will use them a little later:

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/3.06-agent-connection.jpg){: .enable-lightbox}

## Configure Windows System

Now we can configure the windows system itself. We need to install some prerequisites and then install the agent as a service.

### Install the .NET Framework

In an administrative Powershell run the command below to install the .NET Framework

```powershell
Add-WindowsCapability -Online -Name NetFx3~~~~
```

### Install Java

The agent needs a Java JRE installed on the agent machine. I use the Microsoft OpenJDK runtime. You can download it from here:
[https://www.microsoft.com/openjdk](https://www.microsoft.com/openjdk)

If you use [chocolatey package manager](https://chocolatey.org/) you can run the following command.

```powershell
choco install microsoft-openjdk
```

> <span class="badge badge-warning">Licensing Note</span> Oracle Java needs to be licensed for business use. Check your licensing is appropriate.

### Setup Agent

There are a few ways to setup this agent to run on startup. I'll show 2 methods. The first will work if you used the Docker method for creating the master server. If you installed the master using the ubuntu/RPi method then most likely you'll need to use the second method.

> <span class="badge badge-danger">Security Note</span> Both of these methods will have the installed service run as the local SYSTEM user which grants it full administrative rights on the PC. In a production environment you will want to run the agent as a domain user. This can be configured through the normal Windows Service Management. Instructions can be found under the [Configure Slave Service to Run as Domain User section of the documentation here](https://wiki.jenkins.io/display/JENKINS/Installing+Jenkins+as+a+Windows+service)

Jump to the instructions for your method:

- [Docker Master Method](#docker-master-method)
- [Ubuntu/Raspbian Method](#ubunturaspbian-master-method)

#### Docker hosted master method

From the Windows agent system log in to Jenkins and go to the status page for the windows node that was created earlier.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/4.01-agent-connection.jpg){: .enable-lightbox}

Click the Launch agent from browser. This will start an agent with a GUI. Click File and then "Install as a Service". This will fail but will download the files we need.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/4.02-install-as-service.jpg){: .enable-lightbox}

Open an administrative shell and enter the following commands to install the service.

```powershell
cd c:\jenkins
.\jenkins-slave.exe install
net start jenkinsslave-c__jenkins
```

This will start the agent and it will relaunch every reboot. You can skip ahead to [setting up a test job](#create-a-test-job-for-windows-agents).

#### Ubuntu/Raspbian hosted master method

I adapted this method from a [larger method on stackoverflow](https://stackoverflow.com/a/44753306). From the Windows agent system log in to Jenkins and go to the status page for the windows node that was created earlier.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/4.01-agent-connection.jpg){: .enable-lightbox}

Create a folder, c:\jenkins

Download agent.jar (the link specified on the agent page) to c:\jenkins

Create a batch file with the command under "Run from agent command line" which will look like below. Save this as JenkinsService.bat

```powershell
java -jar agent.jar -jnlpUrl http://HOSTNAME:8080/computer/windows-agent-1/slave-agent.jnlp -secret SECRETKEY -workDir  "c:\jenkins"
```

Install [NSSM](https://nssm.cc/), either manually or through chocolatey.

```powershell
choco install nssm
```

In an administrative shell run the following to register this agent.

```powershell
nssm install JenkinsAgent C:\jenkins\JenkinsService.bat
nssm start JenkinsAgent
```

This will start the agent and it will relaunch every reboot.

## Create a test job for Windows agents

From the Jenkins homepage click "New Item".

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/5.01-new-item.jpg){: .enable-lightbox}

Enter the name as Windows-Agent-Test, select Freestyle Project and click save.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/5.02-job-name.jpg){: .enable-lightbox}

In the details for this job enable "Restrict where to run this job" and type the label "windows". This will mean it will only run on the agent we just created.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/5.03-restrict-job.jpg){: .enable-lightbox}

We want to add 2 build steps. First add a Batch command and type the following command to print all environment variables.

```batch
SET
```

Now add a Powershell build step and add the following command. This will print various information about the system.

```powershell
Get-ComputerInfo
```

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/5.04-build-steps.jpg){: .enable-lightbox}

Click save and this will return you to the status page for the job. Click "Build Now" and wait a few seconds for the job to run.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/5.05-job-status.jpg){: .enable-lightbox}

Once you see the job has turned blue in the bottom left you can click #1 and then click "Console Output" to see what was printed out.

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/5.06-job-history.jpg){: .enable-lightbox}

![jenkins]({{ site.url }}/assets/posts/jenkins-home-lab/2019-12-30-JenkinsHomeLab-P3-WindowsAgents/5.07-console-output.jpg){: .enable-lightbox}

## What's next?

We now have a fairly robust lab for working with any kind of job, however managing agents can be kind of annoying, and there is always potential for dependencies to be installed on them which are not documented, or older versions conflicting with newer builds. We can solve these types of issues by dynamically creating agents and installing dependencies as needed. Tomorrow we'll setup a linux docker host and setup on-demand agents.

## Troubleshooting: Updating Java Runtime

If you have previously followed this guide and need to update your java version here are the guides. It's slightly different depending on if you used the NSSM version or the docker hosted self contained agent version.

### NSSM Method

#### 1. Remove previous Java versions

If using chocolatey, you can do the following:

```powershell
choco uninstall javaruntime
choco uninstall jre8
```

#### 2. Install Microsoft Open JDK

Available here: [https://www.microsoft.com/openjdk](https://www.microsoft.com/openjdk)

If using chocolatey you can do the following:

```powershell
choco install microsoft-openjdk
```

#### 3. Reboot your agent. It should automatically reconnect

### Self-Contained Method / Docker Hosted version

#### 1. Remove previous Java versions

If using chocolatey, you can do the following:

```powershell
choco uninstall javaruntime
choco uninstall jre8
```

#### 2. Install Microsoft Open JDK

Available here: [https://www.microsoft.com/openjdk](https://www.microsoft.com/openjdk)

If using chocolatey you can do the following:

```powershell
choco install microsoft-openjdk
```

#### 3. Modify Jenkins Agent launcher config

Modify ```C:\jenkins\jenkins-slave.xml``` and change the ```<executable>``` field by stripping out the path to be just:

```powershell
java.exe
```

#### 4. Reboot your agent. It should automatically reconnect.

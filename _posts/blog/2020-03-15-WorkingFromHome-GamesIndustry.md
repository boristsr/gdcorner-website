---
layout: post
title:  "Working from home in the Game Development Industry"
date:   2020-03-15 11:17:13 +1100
tags: [Development, RainbowRedux, UnrealEngine, UE4, RainbowSix, Release, Github, OpenSource]
ogimage: "/assets/posts/2020-03-15-WorkingFromHome-GamesIndustry.md/wfh-og-image-2.png"
comments: true
permalink: /2020/03/15/WorkingFromHome-GamesIndustry.html
categories: Blog
---

I spent nearly 4 years working as a lead programmer in the game dev industry entirely from home, along with a team spread across the globe. With the recent fears, travel restrictions, lock downs and other chaos around the novel coronavirus, COVID-19, I thought I’d share my experiences with remote working. How a large project with a large global team managed to function with almost everyone working remotely.

The games industry has some particular challenges with working remotely. There are the issues all companies face like IP agreements, the risk of leaks and maintaining communication. The games industry typically also has to deal with extremely large project sizes which further complicates matters.

<!--more-->

## Background

For context of the challenges and solutions discussed, I was a lead programmer on a project for 3 years and then later setup the initial network infrastructure for a new company formed by some of the team members, including an office HQ and remote workers. The first project was run in collaboration and under the banner of a much larger studio that wanted to explore a new way of running a project. The project team size was up to 50 people and the new company was around 30 people including staff and contractors at the beginning. The main project and my involvement with the newly formed company was between 2010 and 2014. Many of the challenges remain the same, but there are many more and newer tools to help deal with them.

I haven’t mentioned names as I am not speaking on behalf of these companies, but rather my experiences with these challenges. To be clear, even though I’m not mentioning names, all parties were amazing to work with.

The projects were PC games, so we didn’t have to deal with issues around console devkits, or controllers. Although [this article may help with remote access with controllers](https://www.gavpugh.com/2018/10/03/using-game-controllers-over-a-remote-desktop-session/).

## Training and Documentation

In many offices this falls by the wayside as you can just ask the developer next to you. There is a lot of knowledge shared vocally. One of the first lessons learned was that documentation had to be kept up to date as a priority. You couldn’t always guarantee someone would be online when information was needed.

Any time a new method of working was introduced or a new technology was used, the documentation had to be updated. If you find repeated requests for guidance, it probably means something is lacking in the documentation. Make sure it can be found with easy key words, and don’t make it long winded and wordy or people will gloss over it. In many cases lots of clear screenshots with a few sentences here and there to describe what is happening is enough.

This ended up being very effective, and definitely helped with autonomy of the team members. The focus on good documentation lead to surprisingly easy rollouts of new version control software and VPNs, even on unmanaged machines. It also produced excellent guides on content creation, and other project related workflows.

Personally I think this felt like it was more effort at the start, but the effort pays off and after a short while ends up being a net positive. Especially as people start asking each other the same question, they just end up passing around the same link or document. It really accelerates how quickly people get their answer and reduces the load on any individual.

We were using Google Docs quite extensively on private accounts for much of the original project. When our development pipeline got closer to the affiliated company we transitioned to storing documents in version control to better align with their processes. This felt like a step backwards in terms of usability. It added an extra barrier to updating documentation. Once the new company had formed, we setup a GSuite Apps subscription, and transitioned a lot of documents to Google Docs, which was and is fantastically useful.

## Remote Access

Developers used their own PC, until we setup an office at which point it started to transition to company supplied and centrally managed systems. The BYOD nature made it tricky to ensure there was appropriate documentation for VPN configuration, and that everyone had installed antiviruses.

OpenVPN was the primary VPN used. This wasn’t the fastest VPN around, but it was free and was an SSL VPN. This meant it would have no issues with NAT traversal like you might find on L2TP/IPSec VPNs which were popular at the time. NAT traversal was a significant factor in the decision as it would have been a significant issue to try and support the variety of routers and modems that team members would have had.

[Split tunnels are becoming a hot topic this week](https://arstechnica.com/information-technology/2020/03/microsoft-and-ars-advise-split-tunnel-vpns-to-minimize-coronavirus-woes/), and this was something we had to do despite many recommendations not to do it. It was not feasible to route all traffic through the VPN for many reasons. Bandwidth required, system load, user privacy, etc. A significant factor though was it would have had a major impact on the internet speed of users, since all traffic would be routed to potentially the other side of the globe. This would have destroyed performance on websites hosted geographically close to the user, and ruined the performance advantage of CDNs for them too.

Everyone was encouraged to get the best consumer internet plan available, and required a large quota.

## Version Control - Distributing & Sync’ing the project

The size of one of the projects ended up being around 20-30gb packaged, with the source (from memory) being closer to 70gb. This was a significant hurdle. This is a significant amount of data to synchronise between everyone. Version control behind a stable VPN was essential.

Being that a large portion of games are binary files, locks in version control are still prevalent. I don’t remember the specifics, but I remember we needed to have good discipline with locking only files that were necessary, and unlocking them as soon as possible. Preplanning where possible to minimise interruption between you and other members. This was definitely different than working in an office, where you could just shoulder tap them, or if they were off sick, have it unlocked by an admin. Many of the workflows were also adjusted so there were more smaller files, rather than monolithic maps for instance.

For a portion of one of the projects the builds were taking place at my house, and had to be uploaded on my rather limited 1 megabit up connection. This affected scheduling of work to be submitted for builds, as well as planning of play tests and demos.

There were a few technical reasons for this at the time like needing a GPU instance for the build process, but most of these wouldn’t pose a problem now with GPU accelerated EC2 machines, and improved engine build processes. Everyone is familiar with cloud hosting, there is no reason this shouldn’t be hosted in the main office or on the cloud.

Scheduling of work submission should still be given appropriate thought when planning. Remote workers may take a significant amount of time to upload large files. The risk of failed submissions due to an internet dropout is always present, which will only increase that time.

For version control we bounced between [Subversion](https://subversion.apache.org/) and [Perforce](https://www.perforce.com/products/helix-core). We preferred Perforce but sometimes licensing restricted us to subversion for early stages of projects. Once again, the technology has advanced now. Git LFS now exists, if you can’t license Perforce or Plastic SCM, Git LFS would be the way to go.

## Real Time Communication (Text, Voice, Video)

This was in the days before Slack, when Skype was still king.

We ran multiple group chats. The main chat room had everyone in there. There were also individual channels for the team leads, the individual teams and a few break out channels.

We didn’t use video chat until much later on, the last 6-12 months. This was primarily used by directors or team leads. Mainly smaller groups to add a bit of personal touch. It simultaneously made it more personal and more official.

Voice chat was used extensively. Individuals could call each other as needed. Sometimes calls just ended up as chit chat and dragged on while people worked, a bit like office chatter.

There were also scheduled meetings. Daily standups of a few people. Weekly meetings involving everyone from every team. These operated pretty much exactly as you would expect. Agenda and minutes all work exactly as in an office.

We found that a voice chat of a larger group required some extra organisation though. First, Skype didn’t really scale to having 10+ people in a single call. We fell back to using a tried and true solution from the games community, [Teamspeak](https://www.teamspeak.com/en/). No one was allowed an auto-activating microphone setting, it had to be Push-To-Talk. There was a bit of individual discipline required as interjecting with an idea while someone else is talking doesn’t work quite the same as it does in a face to face meeting. A text chat to go along with this helps. In the text chat you can raise points for discussion after the current point, or when the speaker has finished.

## Project/Task Tracking & Development Methodology

This worked exactly like it should in an office setting. We needed a ticket/task tracking system, a wiki, project status pages etc. Initially we used [Redmine](https://www.redmine.org/) before moving to [Jira](https://www.atlassian.com/software/jira) for project tracking.

In the early stages of the project we were very ad hoc in planning and management. The company we were working with on the first project guided us into a Scrum based project management workflow. This worked very effectively for us. The standups were easy to organise as a voice call. The sprints allowed us to focus on features and refine them. The preplanned sprint meant there was never a moment when you didn’t know what to focus on, as it was right there on the board. It was a good match.

## Some notes on the softer side of communication

First, body language and other indicators offer so much in face to face communication. Unfortunately, that is completely lost in remote environments. Everyone needs to acknowledge that. When communicating, be vocal about asking for clarification as the speaker won’t see the look of confusion. Also, assume the speaker has the best intentions if something comes across odd, either ask what they mean, or just assume it came across wrong. Don’t let any negative feelings ride.

Our industry already has a [reputation](https://www.gamesindustry.biz/articles/2015-11-17-if-you-all-feel-like-frauds-its-because-youre-really-awesome) [for](https://www.gamasutra.com/blogs/StuartLilford/20170723/302265/Impostor_Syndrome_Im_not_really_qualified_to_write_this_article.php) [imposter](https://www.gamasutra.com/blogs/TanyaXShort/20140716/220938/Overcoming_Impostors_Syndrome.php) [syndrome](https://www.polygon.com/features/2016/1/22/10776792/imposter-syndrome-game-developers-who-feel-like-frauds). I personally found remote working more stressful in this regard. There was a sense of reduced visibility and reduced feedback in communication, it could make you feel like you aren’t doing enough, or that people are expecting more. I tried to be conscious of giving more positive vibes to people. I would advise you to make sure your team makes an effort to be positive. It’s the little things you miss that happen in an office. Things like someone leaning over to see something and going "Oh that’s cool". Just be more mindful about acknowledging wins and recognising effort.

## Takeaways

There are a few main points to take away. Communication at first feels like it takes more effort. It feels more official and less natural. This will pass as you get used to it.

Documentation is essential. This often gets overlooked as it feels unproductive, but the opposite is true. This will pay off in the long run. It will allow people to be more autonomous.

Some extra discipline is required from everyone, and some slight changes to traditional practices can make a big difference in how well they work. For example in larger meetings using Push-To-Talk with a text side channel greatly increases how well they work.

Be more mindful when communicating, acknowledge the reduced feedback that people get. Ask questions more frequently. Try to put a positive spin on both what you say, and what you hear.

There are heaps of tools around to help with these workflows now. The situation is improving every year. I’m sure you look around regularly already, but definitely keep an eye on tools and features that would help with not having a physical presence in the office. [This article highlights some of the popular ones](https://www.linkedin.com/pulse/every-company-needs-remote-work-strategy-survive-chris-herd/).

However, there are plenty of issues left to be solved. Many of these will require changes to what businesses are currently comfortable with. A big one will be data leaving the premises. Commercial contracts will need to be reviewed and adjusted, especially when working on another company's IP.

## Conclusion

This article has been interesting to write, looking back at the challenges we faced and overcame. We were fortunate enough to work with an excellent company that wanted to explore a project run in a very non traditional way, which lead to the formation and growth of an entirely new company. This goes to prove how effective a team can be, even when working remotely.

Today many more tools have appeared. Slack didn’t exist during this time period, and AWS hadn’t quite hit the critical mass it has now. If we could successfully do it back then, it can definitely be done now. At least, from a technical standpoint anyway. I suspect there will be many hurdles to come as businesses and contracts adjust to support these workflows.


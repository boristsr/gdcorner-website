---
layout: post
title:  "4 Problem Behaviours in Software Development Teams and How to Fix Them"
date:   2020-02-28 11:17:13 +1100
tags: [Development, Management, Teams]
ogimage: "/assets/posts/2020-02-28-ProblemBehavioursInSoftwareTeams.md/4problems-og-image.png"
comments: true
---

I’m going to outline 4 common behaviours I’ve noticed and experienced in my time in the game and software development industry. This is by no means an exhaustive list but they are problems I’ve seen crop up repeatedly which can have major effects on team performance and morale. I’ll talk about the issues that follow from these behaviours as well as how to prevent them.

<!--more-->

## Issue 1: Everything is urgent

This is when every task, ticket or issue is assigned with high priority. Managers check in frequently about the status of a different task/issue without giving appropriate time for developers to work through the task. This issue is more likely to appear during crunch time on projects. One time I even saw all tickets on a project reassigned overnight with priorities of "High", “Very High”, and “Highest”. Sometimes this is driven by an approaching deadline, maybe a trade show demo, or sometimes it’s due to pressure from a client and a lack of buffer between client facing people and project teams.

### Why is this a problem?

There are 2 major problems with this.

First, this is a very obvious sign that leadership is scrambling. Issues aren’t being assessed or triaged appropriately. It quickly erodes the teams trust and faith in the leadership to effectively lead this project or team. In my experience this fosters an "Us vs Them" relationship between the team and management as it will strain communication. This will be very difficult to reverse. This has effects that will last well beyond the approaching deadline, with impacts of this erosion of trust and motivation being far greater than the cost of pushing the deadline a little.

In many instances the team will already be working very hard on the project and will already be stressed. Assigning everything as high priority won’t impact the amount of work the team can accomplish, but it will reduce the ability to identify and solve the truly urgent or high value issues first.

Not to mention the demotivating impact of seeing every task assigned as urgent.

![image alt text]({{ site.url }}/assets/posts/2020-02-28-ProblemBehavioursInSoftwareTeams.md/image_0.png)

### The Fix

The main thing here is to keep the project in perspective. It’s important to always appropriately triage issues, regardless of the approaching deadline. Just assigning a new priority won’t help hit the deadline. It’s critical to allow the team to focus as best as possible on delivering the highest value/best product even if overtime or crunch is required.

Try these steps:

1. Look at the remaining tasks.

2. Sort them into a more realistic set of Low, Nice to have, Medium, High and Critical priorities.

3. Get new realistic time estimates

4. Start looking to reduce scope for the deadline or move the deadline.

Ofcourse, reducing scope or moving deadlines isn’t always easy or possible, but if the team is already doing overtime then assigning everything as high won’t help you deliver and will only reduce the effectiveness of the team.

If this is the result of conflict with the client then it’s for leadership and client facing roles to deal with. Create a buffer and reassess these issues and priorities internally. Continue working in a manner that helps deliver the best product efficiently. It’s better to do this than just shifting the heat to the rest of the team.

## Issue 2: Bypassing process to report issues and make changes

This is usually a product manager, or account director or similar person comes in and shoulder taps a developer to ask for a change or report a bug. Sometimes there is a sense of pressure imposed due to their position or that they are busy. The developer then either reports the issue for them, or just straight up makes the change.

### Why is this a problem?

The issues here are around project management, issue tracking, budgeting and slowing down developers.

Bypassing the process will reduce the project managers ability to track costs on the project, as well as reduce visibility on areas of the project that are causing the biggest problems. When you can’t identify the areas that are causing the most problems and changes, then you can’t appropriately track costs or plan work to focus on improving those areas. This will also reduce the ability to see the longer term time and budget costs for this change, as it may impact other features or introduce new bugs.

The new issue isn’t necessarily all that big in the scheme of things, and it could be taking away time from higher priority tasks. The task needs to be triaged and prioritized against the rest of the project. The project manager, scrum master, lead developer and others are best suited to this task. Allow them to do their job and slip this into the appropriate work stream.

It’s very likely the issue is being taken to the wrong developer. The chosen developer may be overloaded with tasks, or possibly isn’t able to do the task as well or as efficiently as another developer. Once again, people closer to the project team are in a better position to judge this.

[Michael Allar recounts an instance of similar misreporting and mis-assignment of tasks, with a costly outcome.](https://allarsblog.com/2018/03/17/confessions-of-an-unreal-engine-4-engineering-firefighter/)

> They were so exhausted of the situation that they just simply started doing what their tickets said. One of the network engineers spent 3 months learning and working on animation graphs because of this.

And lastly, interrupting developers has effects that are well documented. It impacts the so called "[flow state"](https://stackoverflow.blog/2018/09/10/developer-flow-state-and-its-impact-on-productivity/), [slows pace of development](https://jaxenter.com/aaaand-gone-true-cost-interruptions-128741.html), [increases bugs](https://www.brightdevelopers.com/the-cost-of-interruption-for-software-developers/), [increases frustration](https://www.developer.com/mgmt/the-real-cost-of-interrupting-your-development-team.html), and [so on](https://www.gamasutra.com/view/feature/190891/programmer_interrupted.php).

[![image alt text]({{ site.url }}/assets/posts/2020-02-28-ProblemBehavioursInSoftwareTeams.md/image_1.png)](https://heeris.id.au/2013/this-is-why-you-shouldnt-interrupt-a-programmer/)

### The Fix

The best thing you can do is make it stupidly easy for people to report issues or request changes officially, be transparent and try to action them as quickly as is reasonable. Whether that's by nominating someone to be the go-to contact, or accepting changes via one-liner emails is up to you. Choose what will best fit your organisation. People are shoulder tapping because it gives them quicker results and feedback than the official method, with less friction too. So whatever you choose you need to keep these 3 goals in mind:

* Quick response, feedback or action

* Transparency and easy status updates

* Minimal effort to request

Empower your developers to redirect these requests to official channels. Let them know you have their back and they won’t be in trouble for not immediately actioning these requests.

The flipside here is that you don’t want to encourage a culture of brush-offs. I’m all for teams being responsive and helpful. It’s just that a balance is required.

## Issue 3: Blaming Individuals

Picture this scene: A deadline is looming, the client wants to see progress, stress is through the roof, and suddenly the project grinds to a halt because someone took down the dev environment. "Who pushed that change?", “How could you be so reckless?”, the accusations start flying. It’s not a good situation.

I once witnessed something similar when the team had been working for 3 weeks straight, hours ranging from 9-14 hours per day and yet the immediate response was to blame an individual. It’s pretty clear these conditions are bound to lead to mistakes, it just so happened to be that poor dev at the keyboard when it happened.

This doesn’t have to be an urgent problem like described above either. Blaming any bugs on individuals isn’t a helpful action.

It’s easy to point the finger at an individual that made the last change to a module or handled the last deployment. However, is that really the problem? Usually there are deeper issues. Yet someone has just been singled out, embarrassed and become further stressed out.

### Why is this a problem?

The first reason this is a problem is because it’s unproductive. Interrogating a team member over a bad change doesn’t bring the server back online. The first focus should be on resolving the issue. The second focus should be on resolving the root cause that allowed the issue to occur at all.

Blaming an individual will stop you identifying the root cause of an issue. The root cause could have been overwork, inappropriate filesystem permissions, a lacklustre release process, a lack of automation, poor testing strategy, or a combination of these issues and more. Without solving the root cause you are going to suffer the same issue again.

The blame game only further increases stress and tensions in a team. When mistakes are blamed on individuals, and worse, publicly called out, this isn’t good for the engagement or mental wellbeing of your developers.

And lastly, it ignores 2 fundamental truths of software development. 

1. **Software development is a team effort**.

2. **Bugs and issues will happen**.

These are why we have QA teams, tools to check for issues, unit tests, release processes and so on. **Bugs getting through to deployment is not a failure of an individual**.

### The Fix

Identifying the root cause is the key to preventing more issues in future. Once you’ve identified the root cause, you can start actioning change to reduce the chance of the issue reappearing.

#### Overtime / Stress

If it’s overtime or stress related, the answer is to look at your scheduling. It’s [well](https://www.roberthalf.com.au/blog/jobseekers/could-working-overtime-make-you-less-productive) [documented](https://lengstorf.com/overtime-hurts-productivity/) that [overtime](https://www.salon.com/test/2012/03/14/bring_back_the_40_hour_work_week/) and [stress](https://ronjeffries.com/xprog/articles/jatsustainablepace/) [lead](https://medium.com/@plainprogrammer/overtime-hurts-your-software-your-team-1c16c99e28aa) [to](https://lostgarden.home.blog/2008/09/28/rules-of-productivity-presentation/) [mistakes](http://www.effectiveengineer.com/blog/why-overtime-doesnt-work) and [reduced](https://cs.stanford.edu/people/eroberts/cs201/projects/crunchmode/econ-software-differences.html) [efficiency](https://codeahoy.com/2019/10/19/do-software-developers-work-weekends-work-life-tech/). Once these mistakes appear they will occur more and more frequently. An increase in mistakes and poor decision making is one of many ways overtime actually slows development beyond a short stretch of increased output.

While many charts will claim a maximum effective length of overtime, maybe something like 3 or 4 weeks, it’s important to keep in mind that even if that’s an accurate time frame, these are an average for the whole team and will vary depending on the extent of overtime. Some team members won’t be able to keep up that long, some will keep up longer. It all depends on the individual and their circumstances. Keep this in mind when scheduling.

#### Process Issue and/or Poor Automation

If the root cause is a process issue, investigate the process. A process issue could be an incomplete process, an edge case not discovered yet, people bypassing the process, or more.

A build or release process is meant to be clear about the work required. If the process is cumbersome or takes too long, it’s going to be bypassed. If a team member is unfamiliar with the process, they won’t adhere well to it. Maybe the process itself is just missing some steps.

The goals of any release or build process should include:

* Provide a clear path to the goal / Remove ambiguity
* Identify all steps, technical as well as managerial (such as approvals)
* Provide the right safety checks
* Reduce management overhead
* Reduce manual work

Where possible all steps in the process should be automated. Human mistakes can’t be made if a human isn’t involved. **Automate everything possible. **If you can’t automate steps, tasks or processes, look into why. Try and change the surrounding factors to allow automation. It’ll be cheaper, easier and preferable in the long run.

#### Too Much Access

Another possible cause may be that developers have too much access to systems that they shouldn’t have had. Maybe they provisioned too many servers, or wiped a filesystem on the wrong server. Whatever it is, there should be appropriate permissions and quotas in place to prevent these sorts of accidents. Talk with IT, the DevOps engineer and the developers to reassess these permissions.

Many developers may instantly baulk at this conversation. In too many companies the fights have taken too much time to get extra permissions for developers to allow them to reach full productivity and use all their tools, but hear me out. As a developer myself, I know how much the beloved "admin rights" is beneficial to developers. However, as systems get closer and closer to production this access can and should be reduced. Get the conversation happening and choose what will provide the stability your team and project requires, without hindering development. A graduated access scheme similar to below may be appropriate. 

* **Developers machine** - Administrative permissions.

* **Dev Environment** - Administrative permissions. This environment should never be relied on for stability, and processes should be in place to quickly reset, restore or re-provision this environment. There should be low danger from giving extra access to this environment. It will help with debugging, data collection, and so on.

* **Test/UAT** - Reduced permissions. This will help identify any of those missing steps in deployment where you hear "oh, you just need to install this dependency" or “just change this config”.

* **Staging/Production** - None/minimal access. Ideally only automated processes will touch these machines. Any extra permissions should be provided temporarily as part of incident response or change processes.

## Issue 4: Inappropriate responses and focus on bugs during development

This is somewhat related to other points, "everything is urgent" and blaming individuals. This is when someone starts blowing a bug or issue out of proportion, possibly naming and shaming people. Certainly they are trying to get their issue actioned as quickly as possible.

I’ve seen producers and project managers single out developers in front of team meetings over trivial issues that are painted as major failings completely blocking progress. The team members see right through this. It doesn’t earn respect, or change the facts. It’s pure hyperbole.

This can also arise from a bug that's experienced during a demo. This is especially likely if the demo strays off topic away from the feature being demonstrated. It’s not uncommon for people unfamiliar with development to get hung up on otherwise small details which, in turn, lights a fire under the people running the session.

### Why is this a problem?

#### During a demo / feedback session

If the demo isn’t brought back on topic it will drastically reduce the effectiveness of the feedback session. It’s crucial to keep the focus.

Not keeping demos focused will reduce feedback and responses on the area of actual interest, and instead gather feedback on something irrelevant that is probably already known (like pointing out that Section B doesn’t come up when I press the button). This is exactly the reason a lot of web designers use the ["lorem ipsum"](https://en.wikipedia.org/wiki/Lorem_ipsum) text, it effectively shows how the page looks with realistic looking text, while only showing latin gibberish which prevents people from fretting over early wording of copy.

#### During normal development

Blowing out the significance of trivial tweaks after major features being implemented completely demotivates developers. It ignores the significance of the accomplishment and turns it into a negative.

These sorts of responses encourage bypassing proper issue triaging and response. The person raising this is trying to elicit a response of this being urgent and above all else, outside of the normal stream of work. This feeds back into many of the same points in Everything Is Urgent, including difficulty tracking costs and issues.

There are very few situations in development where raising issues like this is beneficial. If the product is still several months from release, nothing is this urgent. The exception being when a demo is being prepped, in which case some time should have been scheduled for ad-hoc polish work.

These sorts of reports, or exaggerated focus on issues will turn the team defensive with an "Us vs Them" attitude. They will start operating in a manner that reduces the chances of this happening. They may reduce communication, lower the amount of attention paid to the people raising these issues or stop doing any work above and beyond what is assigned so they have to deal with this less. None of these are desired outcomes.

### The Fix

#### During a demo / feedback session

Make sure you, or someone from your team is leading the session. This will enable you to introduce the features you are trying to demonstrate and steer the conversation around areas and features you want feedback on. It’s also an effective way to highlight the successes so far.

If this continually occurs the people who are more experienced with client interactions should step in here. They should be able to highlight that it’s still under development and gracefully steer the session on topic again.

#### During normal development

It’s important to identify when issues are being over exaggerated and draw attention to it. It’s not helpful, and detrimental in the long term. Everyone needs to keep perspective of the project and issues.

I won’t speculate on the motivations of people who raise issues like this. Let's give them the benefit of the doubt and say it’s either due to pressures on them from outside sources, or that they are unfamiliar with the development process. Either way, it’s important to recognise that raising trivial matters as urgent, especially if raised disrespectfully, isn’t acceptable. Call this behaviour out, or otherwise contain this behaviour.

## Takeaways

It is important to make a few points. First, project directions and priorities do change. Developers and managers need to be prepared to handle and manage this. This is normal. There is a balance though where this can become too common, not give teams adequate control over the change, and sometimes appropriate changes to the budget and timeline are not made. Exceptions will always be there, but that’s what they should remain, exceptions to the norm.

Second, it’s also important to acknowledge that dealing with clients and people outside the software development world is messy. They have their own challenges, understandings and requirements to work to. These problems will always be there, but that doesn’t mean we need to let the tensions permeate entire teams, and certainly we should strive to prevent as many of these issues as possible.

Third, I’ve been speaking from both a team lead and development manager's point of view. As a manager your job is two fold. Inwardly, you are representing the company, advocating the company’s direction, trying to steer teams, and keep the teams working effectively. Outwardly, you are the face and advocate for the teams in your care. This can be tricky to juggle, but I've tried to keep an objective and balanced view on these issues to offer practical advice.

The main takeaways from this should be:

* Keep the project in perspective
* Treat people with respect
* Look for root causes of issues
* Celebrate wins, don’t focus on the negative
* Ensure changes and bugs are tracked for appropriate budgeting and system insights
* Your team's trust, respect and stress levels all impact effectiveness in big ways. Don’t trade these lightly for a deadline.

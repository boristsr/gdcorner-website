---
layout: post
title:  "Evaluating Project Dependencies"
date:   2019-06-10 15:17:13 +1100
tags: [dependencies, python, RainbowRedux, development]
comments: true
permalink: /2019/06/10/EvaluatingProjectDependencies.html
categories: blog
---

With dependency management tools like NPM, PIP and other similar tools it’s easy to just add another library dependency to a project without much thought. However, dependencies do add weight and cost to a project. The costs could be time, money, and potential sources of bugs. The libraries also have different levels of support. So how do you weigh up using a new library or extending an existing library? When is it appropriate to roll your own?

<!--more-->

I’ve decided to share a few things I consider when adding a library dependency to a project. I’ll mainly focus on the decisions behind using an open source library, as the considerations are a little different for a commercial/closed source library.

I won’t be moaning about the [left-pad debacle of 2016](https://arstechnica.com/information-technology/2016/03/rage-quit-coder-unpublished-17-lines-of-javascript-and-broke-the-internet/), or [over use of trivial packages](https://medium.com/commitlog/the-internet-is-at-the-mercy-of-a-handful-of-people-73fac4bc5068), or reminding you to be [more specific](https://60devs.com/npm-install-specific-version.html) with your [dependency versions](https://pip.readthedocs.io/en/1.1/requirements.html#freezing-requirements). Instead I’ll focus on some of the questions or evaluation points I go through when deciding whether to include a new dependency.

I’ll start with a recent example from a project I’m working on. [RainbowRedux]({{ site.url }}{% post_url /2019-01-13-RainbowSixRevivalProject %}) is requiring more and more linear algebra functions like matrix and vector operations. So far I’ve scraped through with a design that has allowed me to leverage the math libraries of the supported engines, and keeping the core library independent of this code.

Increasingly I require some linear algebra functions in the core library. Standard responses online point people to just use NumPy. NumPy is a great library that provides a huge amount of functionality. It is extremely fast, well tested, well supported, and provides the exact functionality I require.

Unfortunately NumPy is also nearly 50mb (as of 1.16.4 on windows). This increases the project size by about 50%. In modern computing terms that’s not huge, but it’s a bit extreme for the few vector and matrix operations that I require. I also don’t require the speed boost that having a compiled library provides. So I began looking into alternatives.

## What functionality do I require?

This seems obvious because why else would you be looking at libraries? But I like to look a bit deeper in to what I require. What functionality I might require in future that a new library would also solve. I like to understand how an ideal library would fit into the project.

Sometimes existing libraries may not fit exactly how you want them to. Perhaps they operate in a specific way which doesn’t match your design and will require extra effort to either wrap the library or modify your design to suit. By having a better understanding I am able to better evaluate the different options.

In my example I’d prefer a math library that doesn’t require me to instantiate vector classes for every vertex in the scene. Instead I'd prefer a library that offers functions that operate on lists or other iterables. Any changes to existing data structures would require a fair amount of code to be updated, while needlessly adding additional data conversions.

## How well used and tested is the library?

I like to evaluate the library's ecosystem, especially on commercial projects. How many people use it? How active is the community? Are questions and issues addressed quickly?

The more active the community is indicates how well supported it might be. I browse through the outstanding and recently fixed issues to get an understand of what problems I may encounter, and maybe get a sense of the weak points of the library.

None of the answers to these questions are necessarily deal breakers because with open source libraries you can always branch the project to extend it or fix issues. However you need to make sure you have the time and skill base in your team to take on this additional work and responsibility.

## What is the license for this library?

This is probably one of my biggest concerns with unchecked dependency usage. Evaluating how a dependency is licensed is critical. Some licenses have big ramifications on how your can distribute your product or code. A good place for getting an understanding of common open source licenses is to read the summary and the text at [https://choosealicense.com/](https://choosealicense.com/), however always read the license directly embedded with the library. Sometimes changing the design of the system and reducing coupling with a dependency can help mitigate some of these restrictions.

In commercial settings your company possibly already has identified acceptable licenses, or has a process for evaluating a new license. When in doubt definitely speak to someone with a good grasp on software licensing or raise the issue with your lead or manager.

## Before rolling your own...

It can be tempting to fall into the trap of reinventing the wheel, but it’s rarely a good choice for anything that's not trivial. Sometimes this is referred to as [“Not Invented Here Syndrome”](http://www.informit.com/articles/article.aspx?p=1905548). Before going down this path make sure you do the following:

- Have a good look around at the alternatives and have a good reason why they don’t fit.
- Evaluate how much time it will REALLY take, don’t be optimistic with your estimate.
- Consider the cost of further extensions and the high likelihood of future bug fixes and maintenance.
- Consider if the required functionality is the central focus of your project. If it’s not, it’s unlikely to be a wise time investment.
- Are you well versed in the issues the library is trying to solve? If it’s not a subject you are familiar with it’s quite possible you underestimate the work required to solve the problems in a timely fashion or with a manageable interface.

Make sure to evaluate this over time too. An example of mine: a few years ago I needed to integrate [Unreal Engine 4](https://www.unrealengine.com) with a few services and the best way was to expose a JSON API via HTTP. I ended up choosing a [C++ library that provided a basic webserver implementation](https://pocoproject.org/). I did a basic integration with the engine which met requirements, but there was still plenty of improvements to be made. 2 years later I required similar functionality. Unfortunately the plugin I made was no longer compatible with the new version of Unreal and would require a few changes to match the new APIs. I had a quick look around and discovered a [more complete plugin](https://www.unrealengine.com/marketplace/en-US/slug/unreal-web-server) with support was available for pretty cheap. The web integration required by the project wasn’t the main focus, so purchasing the new plugin allowed me to focus on solving the more interesting aspects of the project. It no longer made sense to keep my plugin up to date.

## So, what did I choose?

Despite all my warnings above, I did decide to roll my own vector and matrix library, as my requirements are fairly trivial. The library totals around 100 lines. I’ve written basic vector and matrix classes several times before so I had a decent understanding of the work involved. After a while it was going to take longer to find the perfect library than just writing my own. If I start requiring a faster solution or more advanced functionality I will re-evaluate.

When I went through the same process for an Image IO library I chose [Pillow](https://pillow.readthedocs.io/en/stable/) as it was a significantly smaller library than NumPy (~4mb), it fit my needs, it is well supported, it’s license is permissive and I definitely didn't want to be spending significant amounts of time deciphering the JPEG or PNG formats.

## How do you evaluate your libraries?

It’s worthwhile considering how you evaluate libraries. Sometimes there are risks or restrictions brought in. Sometimes it contributes to project bloat. It’s helpful to consider the process behind adding dependencies and reviewing existing dependencies on all projects to help counter these issues. Maybe it might help you find some better ones too.

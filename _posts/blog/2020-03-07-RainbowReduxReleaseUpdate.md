---
layout: post
title:  "RainbowRedux First Release & Status Update"
date:   2020-03-07 11:17:13 +1100
tags: [Development, RainbowRedux, UnrealEngine, UE4, RainbowSix, Release, Github, OpenSource]
ogimage: "/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/rr011-og-image.png"
comments: true
permalink: /2020/03/07/RainbowReduxReleaseUpdate.html
categories: Blog
---

Some big news today for RainbowRedux. The first release is now available, the Unreal project has been made open source, and there is a new [Discord server](https://discord.gg/YygR4S8) to follow development. Read on for more details!

<!--more-->

## First Release

The first binary release is now available for RainbowRedux. This will ask you to locate your installed copy of Rainbow Six, and then allow you to load maps to explore them. Detailed release notes are available [here](https://github.com/RainbowRedux/RainbowRedux/blob/master/Documentation/Release%20Notes/ReleaseNotes-0.1.1.md).

[Release Notes](https://github.com/RainbowRedux/RainbowRedux/blob/master/Documentation/Release%20Notes/ReleaseNotes-0.1.1.md)

[Download](https://github.com/RainbowRedux/RainbowRedux/releases/tag/v0.1.2)

<div class="embedvideo">
<iframe width="100%" height="100%" src="https://www.youtube.com/embed/lF2UFoP8VMk" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Screenshots are available at the bottom of the post.

## RainbowRedux Unreal project is now open source

After some effort to reduce the build size, and strip out example assets from Epic Games, the Unreal project files have now been released under the MIT license. This will allow more developers to look at the project, track progress and contribute.

You can find the project on the [RainbowRedux Organisation GitHub page](https://github.com/RainbowRedux).

[RainbowRedux Unreal Project](https://github.com/RainbowRedux/RainbowRedux)

[RainbowFileReaders Python Library](https://github.com/RainbowRedux/RainbowSixFileConverters)

## Community Expansion

### Development Discord

I’ve had a few people ask how to contribute, and I’ve been thinking how to open up the development process more. I’ve created a Discord server to allow faster interaction with people. Despite the name, this isn’t just focused on RainbowRedux. Any project related to older Red Storm Entertainment (RSE) games, like Ghost Recon and others are all welcome on this server.

[Join us on Discord here](https://discord.gg/YygR4S8).

### RainbowRedux GitHub Organisation

[Alex Kimov](https://github.com/AlexKimov) and I have recently agreed to start closer collaboration between our projects, and create a single place for information on file formats and development on older RSE games. As part of this there is now a RainbowRedux organisation on GitHub to house many of the related projects.

[RainbowRedux Github Organisation](https://github.com/RainbowRedux)

### RSE file format & technical wiki

To better share the information discovered about these older games we are attempting to build a central wiki with file format descriptions, and related technical information. Over time this wiki will grow to cover Rainbow Six, Rogue Spear (and it’s expansions), as well as the first 2 Ghost Recon games.

[The wiki is available here](https://github.com/RainbowRedux/RainbowWiki/wiki).

## A roadmap change

RainbowRedux was always intended to be a replacement engine for Rainbow Six and Rogue Spear, with a stretch goal of newer RSE games like Ghost Recon. This is still the ultimate goal, except the focus has narrowed to allow quicker progress.

I was attempting to simultaneously support Rainbow Six and Rogue Spear, however the file formats reached a point where they were too different. This is especially true of the more detailed data structures for rooms, portals and dynamic objects in Rogue Spear maps. Trying to achieve both at once is slowing development too much.

So now the project is going to be done in phases. Rainbow Six and Eagle Watch are the first goal, with the other games to follow in order. Something like this:

1. Rainbow Six ( + Eagle Watch)

2. Rogue Spear

3. Rogue Spear Expansions

4. Ghost Recon games (stretch)

Simultaneous support for more games will be possible if someone is willing to take the lead on that front.

### Screenshots

![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_0.jpg){: .enable-lightbox}
![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_1.jpg){: .enable-lightbox}
![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_2.jpg){: .enable-lightbox}
![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_3.jpg){: .enable-lightbox}
![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_4.jpg){: .enable-lightbox}
![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_5.jpg){: .enable-lightbox}
![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_6.jpg){: .enable-lightbox}
![image alt text]({{ site.url }}/assets/posts/2020-03-07-RainbowReduxReleaseUpdate.md/image_7.jpg){: .enable-lightbox}

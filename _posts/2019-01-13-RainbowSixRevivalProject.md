---
layout: post
title:  "Rainbow Six Revival Project"
date:   2019-01-13 20:17:13 +1100
tags: [rainbowsix, gamedev, superresolution, rendering, progress, RainbowRedux]
comments: true
permalink: /rainbowsix/gamedev/superresolution/rendering/progress/2019/01/13/RainbowSixRevivalProject.html
categories: Blog
---

[Rainbow Six](https://en.wikipedia.org/wiki/Tom_Clancy%27s_Rainbow_Six_(video_game)) and it’s sequel [Rogue Spear](https://en.wikipedia.org/wiki/Tom_Clancy%27s_Rainbow_Six:_Rogue_Spear) are early defining games in the tactical shooter genre and the legacy remains today in [Rainbow Six: Siege](https://en.wikipedia.org/wiki/Tom_Clancy%27s_Rainbow_Six_Siege).

I've been working on extracting data out of Rainbow Six with the goal of bringing it into a new engine and recreating the game.

Preview of the first mission in Unreal Engine 4
![First attempt in Unreal]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M01-R6-Unreal.jpg){: .enable-lightbox}
<!--more-->

## Background

Early last year I wanted to play these games, unfortunately it turns out it’s quite hard to play these games on modern systems. Rainbow Six is available from [GOG](https://www.gog.com/game/tom_clancys_rainbow_six) although it has some rendering issues and I was unable to get the mission pack Eagle Watch working. I also had no luck getting Rogue Spear to work from my CDs.

It’s a shame these 2 games are so inaccessible these days, and I wondered how hard it would be to extract the data and put them into a modern engine. So one of the projects I’ve been working on in my free time is exactly that. Over time I’ll write about a few of the interesting challenges faced throughout the project such as:

- Issues arising from from vertex based lighting setups in a per pixel lighting renderer
- Differences with old rendering methods and modern physically-based rendering
- How to decode a file format and Interpreting data
- Useful tools for decoding files

The ultimate goal is to rebuild the game code from scratch, but the first step is extract all the assets out of the files.

## Extracting the data

Regardless of if or how the project will end up being released, the content is still copyrighted so the goal is to have a fully automatic process that will convert the assets to open or standard formats which can then be loaded by the new engine on an end users computer without any technical input needed.

I’m using blender for a lot of the 3D and export operations since it’s open source, already has support for a lot of formats, and can run in batch/headless mode.

After some research I stumbled upon a github repo by [Alex Kimov](https://github.com/AlexKimov/RSE-file-formats), which already had a great deal of formats partially documented. The layout of most file formats is mostly documented, with the actual contents of the data structures still being incomplete. This has been a great starting point. Once I began writing python scripts to parse the files I was able to start discovering what many of the undocumented parts meant. Alex and I have been collaborating a lot, sharing a lot of knowledge back and forth which has been really helpful.

This has been an interesting problem, I’ve never really had to work backwards in this way on a file or system. It's an interesting perspective. Remembering how the fixed function rendering pipeline works has been a walk down memory lane, since that’s what I first learned with OpenGL, but I haven’t used it in a long time. It’s so easy just to think in terms of shaders these days you forget how much could be done in the fixed function pipeline. This whole process has been as much about research as it has been about analysing files. Looking up old modding SDKs for the games, the DirectX 8 SDK and tutorials for hints about data structures and rendering functionality. These resources are much harder to find these days because either the sites are gone, or they’ve been de-ranked by search engines due to age and popularity.

## Rebuilding the game

This stage hasn’t started yet. I’d like to remake both single player and multiplayer. To ease the amount of work required for that I’ll probably elect for a more complete engine like Unity or Unreal, rather than go down a similar path to [OpenSAGE](https://github.com/OpenSAGE/OpenSAGE) which is trying to redevelop the engine and open the original binary files at runtime. The idea of a WebGL implementation does have some appeal though, since it's quite an old game which won't require much processing power.

There are a few factors that I still need to weigh up which will help decide on a final engine:

- Adding a method to load original assets at runtime will mean there is no pre-processing step for users, but assets will appear as-is with little opportunity to improve.
- Converting the assets into a native format for a new engine will enable using engine features like baked lighting which require static objects. Recreating them from scratch on each install will prove challenging, as will loading original assets at runtime.
- I’d like to support optionally loading higher detail textures, materials and models, while I don’t have the skills or time for the content side, hopefully some modders will find it fun. These newer assets will need to be in a native format of the final engine.
- These games are based on portals, which is how segments of the map are determined to be visible or not. This also leads to geometry that is not physically possible, like 2 rooms at least partially sharing the same space. This will prove challenging for networking and physics since most engines now assume a physically correct world.

## Tech

The goal is to make a completely automated process which can read the original assets and output the data to open or standard formats. I’m using a variety of software to do this. Here are some of the key interesting ones.

### Python 3.7

All scripts are currently being written in [python 3.7](https://www.python.org/) since it’s really quick to iterate with and there is a lot of software that is already easy to interact with. This means with minimal or no changes the same scripts can be used in Blender, and potentially the final engine.

### Blender 2.8

I’ve chosen to rely heavily on [Blender](https://www.blender.org/) for this project since it has well tested 3D operations that I won’t need to rewrite, as well as excellent format support for converting to other engines. Since starting the project I have upgraded the scripts to the new beta Blender 2.8 since this isn’t a production project and the goal is future proofing.

### 010 Editor

[010 Editor](https://www.sweetscape.com/010editor/) is a hex editor on steroids. This is a piece of software I only became familiar with based off Alex's work. It is incredibly useful for exploring data formats. If you ever have a need to extract data from an unknown format, or recover a corrupted file, or a hex editor in general, definitely look into this software. It’s amazing.

## Current Progress

So far I’m able to completely read all textures, static meshes and have mostly decoded/imported map files. This is the [project repository](https://github.com/boristsr/RainbowSixFileConverters) and I’m tracking the [progress of file formats here](https://github.com/boristsr/RainbowSixFileConverters/blob/master/FileFormats.md). I believe the majority of the work was in the level format which is mostly decoded now, but there is still a lot to go with some remaining challenges.

### Materials

Materials are almost completely understood however texture sampling methods, translucency and alpha masking are not yet configured in the Blender materials. Materials don’t tend to move between software packages especially well. I’m better off redoing the materials in a more complete way in the final engine, so this is really low priority for now.

### Lighting

Lighting is still being worked on. Ambient lighting isn’t currently configured. Fine tuning the lights themselves will be quite time consuming since modern rendering is actually quite different from the technology that was used back in the late 1990s.

The original games use [Vertex Lighting](https://en.wikipedia.org/wiki/Gouraud_shading) while modern rendering is based on [Per-Pixel Lighting](https://en.wikipedia.org/wiki/Per-pixel_lighting). Vertex lighting can still be setup, though I’d prefer to move towards per pixel lighting since it will simplify material setup and allow easier progress towards a HD pack. The main visible issue is currently it’s obvious that lights are placed away from what a player expects would be a light source like a lamp or street light. This was done to drive the vertex lighting in a very controlled way, however it becomes quite apparent with per pixel lighting.

Below are some examples of the strange placement of lights
![Example of lights clearly setup for Vertex Lighting]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M07-Inside-VertexLighting.jpg){: .enable-lightbox}
![Example of lights clearly setup for Vertex Lighting]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M07-Outside.jpg){: .enable-lightbox}

Here is a [let's play by sigonsteele that shows how it looks in the original game](https://youtu.be/FyoSz4xW_9k?list=PLAA66182E9682A667&t=364). Skip to 9:05.

Many modern renderers are moving towards a model known as [Physically Based Rendering](https://en.wikipedia.org/wiki/Physically_based_rendering). This describes how lights behave and interact with the surfaces and materials in the scene. Rendering previously has relied on a much simpler model. The old model only defined an ambient, diffuse and specular property as [described here](https://www.cs.uic.edu/~jbell/CourseNotes/ComputerGraphics/LightingAndShading.html). The lights also shared these properties so lights could give a different specular highlight to the diffuse color the light was producing.

Lights also had 3 attenuation properties [constant, linear and quadratic](https://developer.valvesoftware.com/wiki/Constant-Linear-Quadratic_Falloff). These could all be changed to achieve different effects, however they have mostly been replaced with newer attenuation methods. There will need to be some fine tuning to map the old values to newer lighting models.

## Finally, some screenshots of the progress

### Rainbow Six Mission 01

Office in Embassy
![M01]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M01-R6-OfficeBlender.jpg){: .enable-lightbox}

### Rainbow Six Mission 02 and it's re-release in Rogue Spear Urban Operations

For reference, [here is a let's play by sigonsteele of the mission](https://www.youtube.com/watch?v=LqS8ZYwJGFY) in the original game.

Basement

Rainbow Six
![M02]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M02-R6-Basement.jpg){: .enable-lightbox}
Rogue Spear
![M02]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M02-RS-Basement.jpg){: .enable-lightbox}

Outside

Rainbow Six
![M02]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M02-R6-Outside.jpg){: .enable-lightbox}
Rogue Spear
![M02]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M02-RS-Outside.jpg){: .enable-lightbox}

Sitting Room

Rainbow Six
![M02]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M02-R6-SittingRoom.jpg){: .enable-lightbox}
Rogue Spear
![M02]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/M02-RS-SittingRoom.jpg){: .enable-lightbox}

### Rogue Spear Mission 5 - Example of impossible geometry

From outside the aircraft you can see the Business Class cabin, and others
![RM05]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/RM05-PlaneExterior.jpg){: .enable-lightbox}
From Inside the Business class cabin you can see it's quite large and furnished
![RM05]({{ site.url }}/assets/posts/2019-01-13-RainbowSixRevivalProject.md/RM05-BusinessClass.jpg){: .enable-lightbox}

Stay tuned for more progress updates soon!

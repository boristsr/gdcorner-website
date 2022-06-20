---
layout: post
title:  "Follow the Trail Development Retro Review."
date:   2022-03-23 14:16:13 +1100
tags: [gamedev, gamejam, retrospective, unreal, ue4, project, retro, postmortem]
comments: true
image: "/assets/posts/2022-03-23-FollowTheTrailRetro/ogimage-retro.png"
categories: blog
project: follow-the-trail
---

On Halloween 2021, I decided to try doing a mini game-jam style project. I wanted to make something simple, yet atmospheric. Possibly a simple wave based shooter. There was no solid plan, just an idea to make "something". In this retrospective review, I share some of the goals, strengths and weaknesses of the project, and any lessons learned.

<!--more-->

After every project (even small personal ones) I like to do a small retrospective review, and solidify for myself any lessons that can be learned from the project. This can identify any strengths and weaknesses in my skill set or decision making. This can then be used to guide me in what I want to learn or improve on next. It also serves as a bit of a sense of closure on a project. After all, no project is ever "done".

I've decided to share some of my retro reviews. These are written in bullet point form to minimise time spent writing them, and maximise the value in them for me. Hopefully others can learn something from them, even if it just serves as an example on how someone else does a retro review.

## The Goal

* A project to brush up on areas of Unreal I'm unfamiliar with or haven't touched in a while.

* Make some sort of shooter, probably wave based

* Make it atmospheric and unsettling in that cheesy-popcorn-horror Halloween kind of way.

* Have some creative fun!

## Notes

* Having no plan wasn’t either a positive or a negative in this instance

    * It was a time limited exercise and the point was to see what I could do quickly, not how quick I could do X.

    * As there was no set end goal, jumping around tasks allowed me to let ideas develop in my head while I worked on something else.

    * This is only true because of the Game Jam nature of the project.

## Good

* This wouldn’t have been possible without the incredible assets available on the Unreal Marketplace.

* Ultra dynamic sky, while leveraging underlying systems of unreal, MADE this experience. It’s weather system, and incredibly easy to use interface made it easy to immediately create a deeply unsettling atmosphere

* Using assets but attempting to recreate some of the underlying pieces like anim blueprints, sound cues, etc was a good way to maximise learning.

* Codecks made it really easy to just keep jotting down tasks and marking them off as done

* Changing from a wave based shooter to a more linear experience allowed for a more unsettling experience, rather than just shooting monster after monster.

* Great to refamiliarise myself with the audio system

* Great to get a bit more familiar with animation blueprints, blending and skeletal meshes

* Great to refamiliarise with the behaviour tree and blackboard system

* Darkness hides all issues!

* Happy bugs.

    * I forgot to uncheck "auto activate" on the scream sound cue, so the scream triggers at the beginning of the level, as well as half way through. I left this in as it didn’t detract from the experience, and was kind of a freebie effect.

    * The impulse from the projectiles made the monsters shudder. Ended up being a janky hit effect which kinda worked. So I left it in.

## Bad

* Not having a clearer knowledge of the assets available made it tricky to find what I wanted or needed.

* One of the later discovered assets made me rethink what kind of experience this would be, which wasted time. I decided against using that asset and sticking the original simplistic game ideas

* There is no depth to the combat or gameplay loop. Deeper gun mechanics and more refined monster AI would greatly improve the experience

* Should have had a better plan for routing events between blueprints properly. At the moment they happen all over the shop, breaking encapsulation principles

* Stopped following naming conventions and clean asset practices towards the end

* Realised afterwards the HUD only changes opacity on damage, death and win screen, and doesn’t disable. This probably means the blur effect is happening multiple times even when not visible. Should make sure those get disabled.

## To improve and explore next time

* Having an initial asset review as part of an ideation and planning stage would help formulate a clearer idea of the game earlier.

* Utilise behaviour tree services more, rather than attempting some code in the monster blueprint

* Would like to continue developing these behaviour trees, and other blueprints and start building my own library so I can slap together projects even quicker.

* Monsters don’t follow the player. They move to the place they last checked for the player. Once they have completed the move, they will then look for the player again. If I was more familiar with the navigation system in Unreal I’d have them always moving to the player.

* Darkness and brightness levels ended up causing some concerns I didn't expect. This project was just for my own entertainment, but when I ended up sharing on social media the brightness level proved problematic. I tuned it to look nice on my monitor, but on phones and OLED displays, it shows up too dark, and on other screens it’s very over-bright. For an atmosphere that so heavily depends on the darkness, this could probably have been handled a little better. Maybe a little brighter. In future, definitely have some form of brightness control for users, and when recording a video for social media make sure it’s on the brighter side.

* If this wasn’t a "do anything as quick as possible" experiment, I’d have liked to make my own level, using an auto-material and procedural foliage volumes, and create a longer path

* Make notes throughout of what has been completed in the last 1-3 hours. It’ll make BTS videos easier, and serve as a good reminder of what's been done and how quickly.

## Bugs remaining

* Monsters don’t make a sound when they attack

* Monsters don’t deal damage until their attack animation finishes.

* Monsters don’t continually follow the player, rather they move to the last selected point, and then look for where the player is again, selecting that point, and looping. Easy to move away from the monsters.

* The scream can be retriggered, which breaks the illusion if people go hunting for the scream

* Realised afterwards the HUD only changes opacity on damage, death and win screen, and doesn’t disable. This probably means the blur effect is happening multiple times even when not visible which is quite expensive. Should make sure those get disabled.

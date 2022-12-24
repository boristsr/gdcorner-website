---
layout: post
title:  "Rush Hour - Year in Review"
date:   2022-03-23 14:16:13 +1100
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
image: "/assets/products/rushhour/rushhour-og-v1.jpg"
categories: blog
product: rushhour
---

2022 Has been a fantastic year. [Rush Hour saw its initial release]({% link _products/RushHour.md %}), and great progress has been made on the next version. Before I take a holiday break, I wanted to give a status update on Rush Hour and the plans for the near future.

<!--more-->

I’ve recently received some fantastic news which I can’t wait to share with you all. The future of Rush Hour in 2023 is looking very bright!

## About Rush Hour

[Rush Hour]({% link _products/RushHour.md %}) is a new way to animate vehicles directly in Unreal Engine. Furthering the idea of using real-time game technology to produce movies & animation, Rush Hour utilizes AI drivers to produce physically-simulated & realistic driving animations. There is no need to go back and forth between your DCC and Unreal, as it can be entirely produced in-engine.

{% include youtube.html video="domP9beWhS8" %}

[For more information on Rush Hour, see the full product page]({% link _products/RushHour.md %}).

## Next Year

Early next year, there are a few things I want to tackle.

First, I want to publish the first major update for Rush Hour, Version 1.1. I’ve included more details about this further in the post.

Second, I would like to reshoot the training videos. These will include all the new features and pack them full of tips and tricks. I would also like to make a few videos on topics not directly Rush Hour related, such as how to direct a car chase scene to maximize the sense of speed and movement. Every time I’ve made a new video for social media, or the trailers, I’ve done a better job animating the cameras and improving the sense of speed and motion. I want to share some tips to help others improve their own videos.

Third, I want to spend a week or 2 focusing on making a short vehicle animation video. To date, all the existing examples and promotional videos have been done in less than a day. I want to elevate everything from the camera movements, the materials for the vehicles, and the integration of VFX like FluidNinja, as well as other particle systems and VFX. I want to see how great a video made with Rush Hour and Unreal Engine 5.1 can look with more time spent on it.

## Version 1.1 Progress

I had hoped to submit the 1.1 update to the marketplace before the holidays, but I don’t want to release something that I’m not entirely happy with. Most of the features discussed below are in, but there are some rough edges I want to attack, as well as spend some time fine-tuning the driving profiles. I expect to upload 1.1 to the store in the week January 9 - January 13

As always, [the roadmap is a great place to get a peek at the future plans for Rush Hour.](https://open.codecks.io/rushhour/decks/47-public-rush-hour-roadmap)

### Improved Speed

Due to how handling of path banking (left/right roll) and pitch (uphill/downhill slopes) are improved, vehicles can now much more aggressively attack corners and mountainous terrain.

In one test track, the lap time has gone from over 6 minutes to 4 minutes and 35 seconds!

### Improved Jumps

The above improvements that enabled better and more aggressive speed control have made it easier to animate jumps. Before, you needed to place control points on flat surfaces at key places, but now the path behaves much closer to how you intuitively expect.

### Improved Path Visualizer

You can now see path action points on the path, so you don't need to click through each spline point to find where that damned stop action is.

![Waypoint Markers](/assets/posts/2022-12-24-RushHourYearInReview/WaypointMarkers.png)

### Runtime Path Visualizer

You can now see the path at runtime, including action waypoint markers to get a better idea of how vehicles are responding to your path.

### Experimental BP Runtime Path Creation Support

Some initial work has been done to support creating paths at runtime via blueprints. I expect some edge cases and limits to this, but this should increase flexibility for using this plugin in more kinds of projects.

### Newly Tuned Profiles

To take advantage of the new driving improvements, I need to retune all the driver profiles to ensure they look as good as possible. While doing so, I’ll also address feedback about the “Frantic” profile to make it less twitchy.

### More Example Maps Included

To go with these new features, there are new example maps included

- Banked Race Track Loop Demonstration
- Banked Cornering Test map
- Jump Demonstration
- Runtime Path Demonstration

## Future Updates

Further down the road, there are a number of updates planned. Some of these already in development include:

- A Blender add-on to make it super easy to import your own vehicles into Unreal Engine.
- Real-time Tyre Deformation to make vehicles appear more grounded

{% include youtube.html video="TG-ogmBp51Q" %}

## Holiday Break

I’ve been pushing hard on Rush Hour for most of this year. Over the next 2 weeks, I’ll spend some time with friends and family, recharge and be ready for a solid start to next year. I’ll be taking a break and resuming work on January 9.

**Due to the holidays, support will be delayed for the next 2 weeks. Please ask if you require assistance, but be aware that responses will be delayed and sporadic until Monday, January 9.**

## Wrap Up

Thank you all for the support this year! I can't wait to share what's in store for the future of Rush Hour!

**Best Wishes for 2023 and Happy Holidays!**

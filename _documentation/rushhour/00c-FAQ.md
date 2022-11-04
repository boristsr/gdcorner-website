---
title:  "FAQ - Rush Hour"
subtitle: "Rush Hour Frequently Asked Questions"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
categories: product
version: 1.0
product-type: Tool
product: rushhour
---

# Where can I get it?

Rush Hour is very close to release. Announcements will be made on the [product page](https://www.gdcorner.com/products/RushHour.html), [twitter](https://twitter.com/GDCorner), and in various Unreal Engine social media groups. It will be available on the Unreal Engine Marketplace.

# Where can I see the list of upcoming features?

I have a [public roadmap for post-release updates available here.](https://open.codecks.io/rushhour)

Please note: Anything with no priority, or tagged as unconfirmed is currently being evaluated for feasibility or priority. These items are not confirmed or guaranteed for release.

# How do I hide the watermark in the bottom right?

This HUD only appears in Training & Rush Hour spectator game modes. Change your world settings or project settings to use a different game mode in your animation scenes.

# Why don't the graphs change when I change speed units on the HUD?

Metric units are the native measurements in Rush Hour and Unreal Engine. For this reason, the historical graph data is only displayed in metric units since it's only useful for very fine-grained tuning, debugging, and developing Rush Hour AI.

# My car keeps flipping as soon as it hits the ground or lightly touches an obstacle

This indicates the car being animated is using an unstable physics setup. Compare and copy physics settings and variables from some of the vehicles included with Rush Hour. These have been finely tuned to be stable and behave in realistic and believable ways. Please see the guide here for more tips.

# The cars seem slow. How can I make them go faster?

You can tweak the physics setups of vehicles for better performance, but there will be limits. Rush Hour is designed to produce realistic driving performance and will slow down for corners and on rough terrain.

A sense of speed in the video can be both reduced and increased with camera work and post-processing. Increasing motion blur, changing the field of view, and other camera settings can enhance the sense of motion. Placing cameras low to the ground, having lots of foreground objects, and adding a counter-movement to the camera can also enhance the visual sense of speed. Further post-processing, like vignetting and motion blur, can produce even more dramatic results.

Editing also plays a role. If the car is slowing down significantly during a corner, over a bump, or during a move like a power slide some simple cuts and editing tricks can preserve the sense of intensity and momentum. For example, a cut to a reaction on a face, a close-up of the car or wheel, and then back to a wider shot for context can keep the feeling of momentum and intensity, despite the car actually traveling slowly.

Some more great tips for increasing the perception of speed are available here: [https://neiloseman.com/how-to-make-chase-scenes-look-fast/](https://neiloseman.com/how-to-make-chase-scenes-look-fast/)

# The precision driver and racer are slow

Clean driving often produces faster lap times while appearing slow, even in real life. Perception of speed can be enhanced when the car is just on the edge of being out of control. The precision driver and racer profiles are the fastest. However, if you have tried the steps in the previous tip and still want to enhance the perception of speed, you can try changing the driver profile to "frantic" which will brake later and push slightly faster at corners, causing some rather interesting cornering.

# My cars are spinning out at corners.

Make sure to run the training course on any vehicles that are behaving strangely. If training doesn't improve the performance of vehicles, please ask for support and send the vehicle setup so it can be reproduced.

# My cars are driving excessively slowly around corners after training.

The training has determined that there is something affecting the grip of the vehicle reducing braking and cornering performance. Check suspension settings and tire grip. I'll be providing a guide on how to tweak vehicle physics in the future.

# Vehicles aren't behaving consistently across different terrain types.

Rush Hour currently only supports a default physics material. Support for additional physics materials is planned, but no confirmed date on when this will be supported.

# Why does the training level look so bad?

The training level is designed to use as few resources as possible to produce the most stable physics simulation it can. The more stable and consistent the physics simulation, the better the training results are. For this reason, shadows, ambient occlusion, and reflections are all turned off or as low as possible. Regardless of the power of your PC, this helps contribute to the best training results possible.
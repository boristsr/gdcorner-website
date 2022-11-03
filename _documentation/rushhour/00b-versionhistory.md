---
title:  "Version History - Rush Hour"
subtitle: "Rush Hour Version History"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
categories: product
version: 1.0
product-type: Tool
product: rushhour
---

# Version 1.0.0

- Added a time control feature when using the Rush Hour spectator player controller with number keys. This can make fine tuning paths a little quicker. This is not recommended to be used during training.
- Align-To-Ground feature on paths now has advanced options to ignore actors and actor types, solving the issue of getting stuck on foliage and other volumes
- Training is significantly more reliable and accurate.
- Cornering force is now more accurate measured for vehicles that have low grip
- Training now gives more detailed errors when issues occur.
- Stopping hardness has now been added as a parameter for stop waypoints. This allows more artistic control over driver behavior
- Vehicle profiles now save to the game content directory. This means they will more easily be added to version control.
- Added editor icon for paths to more easily identify and select vehicle paths.
- Disabled Receive Decals on included vehicle meshes to stop road decals flashing over the vehicles.
- Improved driver profiles

## Known Issues

* Some minor deprecation notices may appear during C++ compilation. These are due to API changes in Unreal, and will be solved as older engine support is removed from the plugin.


# Beta 2 (2022-08-19)

* Added a Light Interface which can easily be added to existing vehicles, allowing RushHour to control reversing and brake lights. Additional light controls are exposed in the interface, but there is no way to control them currently.
* Glass now renders before DOF
* Removed Learner profile as it doesn’t offer enough difference
* Begin Training button is now working after first training map load & selecting a vehicle
* Progress tracking on the path when doing large jumps now works more reliably
* Stopped compounding control multipliers which means steering is now less twitchy
* Added additional Steering target samples to reduce unnatural swings in tighter corners
* All references to Wheelman and WM are now replaced with RushHour and RH respectively. Core redirects are still in place to ease transition. These will be removed before final release.
* Paths accidentally saved during play will not stop the vehicle from driving on next playthrough
* 4x4 has slightly improved suspension. Works best at low speed. Example Video: [https://www.youtube.com/watch?v=Pn8E-gLHfZM](https://www.youtube.com/watch?v=Pn8E-gLHfZM)

## Known Issues

* Car references and recorded sequences using Rush Hour vehicles from Beta 1 will not work. You will need to relink cars to paths and re-record sequences.
* Profiles need more adjustments to perform better and differentiate from each other
* Align to ground can be blocked by foliage. Disable collision on foliage or shift your spline point to avoid hitting leaves on the trace to the ground.
* 4x4 suspension requires lots of tweaking to get better behaviour.
* Closed loops with a non-default looping position will exhibit artifacts at the looping point, and will loop with point 0 anyway.
* Training may fail to find a good maximum cornering force value on vehicles with a high centre of gravity. This will be resolved before release.


# Beta 1 (2022-08-01)

 * Initial Beta Release

## Known Issues

* Glass on the example vehicles currently renders after DOF producing ugly DOF artifacts
* Profiles need more adjustments to perform better and differentiate from each other
* Sometimes on the first load of the training map, the begin training button remains disabled. Just load the training map again.
* Progress tracking on the path can fail during extreme elevation changes like jumps or big slopes. To remedy this add extra nodes. This will be remedied in the next release
* Due to a bug discovered in Beta 1, steering is a bit twitchy on all profiles, especially Sunday Driver. This will be fixed in the next release.
* Align to ground can be blocked by foliage. Disable collision on foliage or shift your spline point to avoid hitting leaves on the trace to the ground.
* 4x4 suspensions needs lots of tweaking to get better bodyroll
* Closed loops with a non-default looping position will exhibit artifacts at the looping point, and will loop with point 0 anyway.
* Training may fail to find a good maximum cornering force value on vehicles with a high centre of gravity. This will be resolved before release.
* Saving a path modification made when playing in editor may cause that path to corrupt, requiring it to be recreated. The vehicle will spawn but will not drive.

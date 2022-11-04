---
title:  "Training a New Vehicle - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
youtube_id: yaK5RV-H8LQ
---


# Troubleshooting

Created: October 9, 2022 1:55 PM
Updated: November 4, 2022 5:25 PM

Training has been developed to be as robust and reliable as possible, but it is possible to make vehicles that don't train well. There are various reasons. Here are a few ones to watch for, and suggestions on how to improve

## Unstable Vehicles

If you watch the vehicle training and you notice it bouncing or jumping, that's indicative that the vehicle is unstable. Tweak the suspension and physics setup until it drives steady. When in doubt, reference some values from the included vehicles with Rush Hour for a starting point.

## Exceedingly slow/heavy vehicles

Some vehicles, like construction vehicles with a top speed below 30mph, require full throttle to drive, which can cause Rush Hour to struggle. Increase the engine power until the vehicle drives with a much higher top speed, and then achieve the look you desire by choosing slow speeds on the animation path.

## Colliding with Ground

Vehicles can collide with the ground for a number of reasons:

- the suspension of the vehicle is too soft
- the vehicles have a lot of heavy body roll
- the collision models are too large

These factors can cause the vehicle to collide with the ground during hard turning or heavy braking. The solution is to make the suspension stronger, reduce the collision model size, or combine these.

# Known Compatibility Issues

There are a very wide range of vehicles available on the marketplace, and it's quite tricky to reliably (and quickly) train a profile for such a wide range of configurations. Here is a list of vehicles that Rush Hour is known to have problems with and some suggested changes to vehicles that will improve Rush Hour's ability to train them. Even if you don't use these vehicles, it's worth reading through as you may find similar problems with other vehicles, and these fixes will likely work too.

**This list is in no way a commentary on the quality of these products. It's just a compatibility and troubleshooting list.**

## Driveable / Animated Construction Vehicles Set [ Set of 4 ]

[https://www.unrealengine.com/marketplace/en-US/product/driveable-animated-construction-vehicles-set-set-of](https://www.unrealengine.com/marketplace/en-US/product/driveable-animated-construction-vehicles-set-set-of)

4.x/PhysX

These vehicles drive very slowly and require a very large acceleration force. I suggest giving the vehicles more torque and a much higher top speed which will allow Rush Hour to train profiles for these vehicles. You can always set the animation path to drive these vehicles slowly without limiting it in the vehicle configuration.

## Box Truck - Vehicle Variety Pack

[https://www.unrealengine.com/marketplace/en-US/product/bbcb90a03f844edbb20c8b89ee16ea32](https://www.unrealengine.com/marketplace/en-US/product/bbcb90a03f844edbb20c8b89ee16ea32)

4.x/PhysX

Only the box truck has issues in this pack. The issue stems from the fact that the vehicle naturally slows down quite a bit without braking, and the braking force is quite light. There isn't much of a window between the braking forces. I suggest making the braking force a bit stronger, which will allow more difference between not braking and braking. This will allow rush hour to train a profile for this vehicle.

## [Functional] 4 Russian Military Vehicles / 6 Versions per vehicle

[https://www.unrealengine.com/marketplace/en-US/product/functional-4-russian-military-vehicles-6-versions-per-vehicle](https://www.unrealengine.com/marketplace/en-US/product/functional-4-russian-military-vehicles-6-versions-per-vehicle)

4.x/PhysX

These vehicles have inverted steering. The blueprint configuration uses an inverse axis for steering input. Unfortunately, due to Rush Hour connecting directly to the Vehicle Movement Component, it bypasses this steering setup and the vehicle steers in the wrong direction. I plan to speak with the asset pack maker about this, in the meantime I believe the vehicles will need a new skeleton, so you can try exporting and recreating the vehicles. In the future, I may develop a solution to detect inverted steering on vehicles.

## Classic Sport Car 01

[https://www.unrealengine.com/marketplace/en-US/item/e9e10502e26946d192c243a40e258afa](https://www.unrealengine.com/marketplace/en-US/item/e9e10502e26946d192c243a40e258afa)

4.x/PhysX

This vehicle collides with the ground during cornering and hard braking. The suspension needs to be stiffened.

## RCCar

[https://unrealengine.com/marketplace/en-US/product/drivable-rc-car](https://unrealengine.com/marketplace/en-US/product/drivable-rc-car)

5.x/Chaos

Vehicle doesn't accelerate under some circumstances.

This vehicle will need some attention to identify the cause.

## Trailer - City Sample Vehicles

[https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles](https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles)

5.x/Chaos

This is a vehicle class, but it is not a drivable vehicle. It drags it's front trailer hitch on the ground. There is no need to train this vehicle. You will probably only see this as an error in batch training mode

## BP_Vehicle - City Sample Vehicles

[https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles](https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles)

5.x/Chaos

This vehicle appears to just be a base class, and shouldn't be directly used. The front wheels don't even animate. This seems to train correctly in the editor, but not in batch training mode. I advise just using the other vehicles in the pack.
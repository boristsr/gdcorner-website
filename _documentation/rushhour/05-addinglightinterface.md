---
title:  "Using the Vehicle Light Interface - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
youtube_id: YrnE-N91e30
---

## Vehicle Light Interface

The light interface is an easy way to allow Rush Hour to control the lights on your vehicle. It is called `RHVehicleLightsInterface`

The light interface can be implemented as a [Blueprint Interface](https://docs.unrealengine.com/5.0/en-US/implementing-blueprint-interfaces-in-unreal-engine/) on the vehicle itself, or a component attached to the actor.

[For documentation on how to use a Blueprint Interface, see the official documentation here.](https://docs.unrealengine.com/5.0/en-US/implementing-blueprint-interfaces-in-unreal-engine/)

## Included Example

The included vehicles include an example implementation as a component `BP_RH_Vehicle_Lights_Control_Component`. This simply does a search over the vehicle mesh to find matching Materials, and then swaps them for Dynamic Material Instances. These Dynamic Material Instances can then have parameters adjusted at runtime to change light intensity.

The included example implementation relies on materials controlling their emissive property via a property called "OnAmount". This allows the example component to turn lights on or off by setting the "OnAmount" property to 0 or 1. There is one edge condition on the brake lights, where the `OnAmount` is set to 0.3 when the headlights are on.

## Limitations

* The light interface and included example have functions exposed for controlling all kinds of lights. However, Rush Hour only controls brake lights and reversing lights currently. You can set the other properties via blueprints or sequencer.

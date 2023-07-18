---
title:  "Troubleshooting - Vehicle Importer - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
---

On this page you'll find a variety of common issues people face when importing vehicles with the Rush Hour Vehicle Importer.

## Vehicle attempts to drive sideways

Ensure your vehicle is facing `+X`, and the vehicles left side is pointing `+Y` in Blender

## Vehicle flips out on training / Flies away

Check your vehicle scale in Blender. Please [watch this video at the 2 minute 30 second mark](https://youtu.be/D5Yt90k7Xww?t=158). You can rescale the vehicle at any time. Just make sure you rescale the `vehicle` collection.

- If you are using simple mode, The `prepped` and `export` collections will be updated once you re-export.
- If you are using advanced mode, the collections will be updated as you go through the `Prepare`, `Rig` and `Export` steps again.

{% include youtube.html video="D5Yt90k7Xww" time=158 %}

## Brake Calipers rotating funny

If you have prepped brake calipers in Blender, you need to ensure there are no physics bodies created for them in Unreal. To do this:
- Open the Physics Asset, `PHYS_YourVehicleName`
- Ensure there are no brake calipers on the tree on the left.
- If there are, please select and delete the brake caliper bodies by pressing `Del` on your keyboard.
- Save the Physics Asset.

## The vehicle keeps colliding with the ground during training

- Ensure you have used an appropriate template. Don’t use the 4x4 soft template on a race car for example
- If the vehicle is particularly low profile you may need to adjust the wheels suspension.
    - Open your wheel blueprints and reduce the Rise and Lower

## The vehicle has too much body roll

- You can try lowering the center of mass by going to the `BP_YourVehicleName` blueprint
- Ensure you click `Open Full Blueprint Editor` if you don’t see the components on the Left
- Select the `Vehicle Movement Component` and on the details panel on the right, look for `Center Of Mass Override` and reduce this in 5-10cm increments.
- `Compile` and `Save` your blueprint.

## Wheels are Wobbling

This needs to be corrected on the Blender/Modelling side. On your wheels, please ensure that:

- They are straight
- There is no camber\tilt to the wheel
- The geometry is uniform all the way around
- The wheel is centered on the rim
- The wheels will rotate on the global Y axis; you can rotate them the same way in your modeling program to verify visually before running through the whole process


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

- Ensure your vehicle is facing forwards on the `+X` axis, and the `+Y` axis is pointing to the left of the vehicle in Blender

## Vehicle flips out on training / Flies away

- Check your vehicle scale in Blender. Please [watch this video at the 2 minute 30 second mark](https://youtu.be/D5Yt90k7Xww?t=158). You can rescale the vehicle at any time. Just make sure you rescale the `vehicle` collection. The `prepped` and `export` collections will be updated once you re-export in simple mode, or go through the `Prepare`, `Rig` and `Export` steps again in advanced mode.

{% include youtube.html video="D5Yt90k7Xww" time=158 %}


## Brake Calipers rotating funny

- If you have prepped brake calipers in Blender, you need to ensure there are no physics bodies created for them in Unreal. To do this:
    - Open the Physics Asset
    - Ensure there are no brake calipers on the tree on the left.
    - If there are, please select and delete the brake calipers
    - Save the Physics Asset.

## Wheels are Wobbling

This needs to be corrected on the Blender/Modelling side. On your wheels, please ensure that:

- They are straight
- There is no camber\tilt to the wheel
- The geometry is uniform all the way around
- The wheel is centered on the rim
- The wheels will rotate on the global Y axis; you can rotate them the say way in your modeling program to verify visually before running through the whole process

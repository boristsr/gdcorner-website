---
title:  "Common Blender Fixes - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
---


> <span class="badge badge-danger">Support Note</span> The Rush Hour Vehicle Toolkit Blender Addon assumes that you have a relatively clean, well-prepared model, or that you have the working knowledge of Blender to fix your source models. For convenience I have provided some instructions on simple fixes for common issues [here]({% link _documentation/rushhour/82-common-blender-fixes.md %}), but model clean up and general Blender instructions are beyond the scope of Rush Hour, the Vehicle Toolkit, and GDCorner support. If you need more assistance on cleaning up a vehicle model, you'll need to contact someone more familiar with modelling tools.

## Common Issues and their solutions

Negative Scales → [Apply Transforms](#apply-transforms)

Missing geometry, “inside out” geometry → [Check Normals](#check-normals)

Vehicle not centering → [Check bounds](#check-bounds)

Bad Bounds → [Apply Transforms](#apply-transforms) then [Check unconnected vertices](#check-unconnected-vertices)

Parents and inherited transforms → [Clear Parents and Keep Transform](#clear-parents-and-keep-transform)

## Fixes

### Apply Transforms

Select all meshes by hovering mouse over viewport and press A

Go to the top left of the viewport and Click `Object` -> `Apply` -> `All Transforms`

![Apply All Transforms]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled.png)

Apply All Transforms

### Check Normals

In the top right of the viewport there is a button that looks like 2 overlapping circles with a drop down next to it, called `Viewport Overlays`

Click the Drop down

Turn on `Face Orientation`

![Enable Face Orientation Overlay]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%201.png)

Enable Face Orientation Overlay

The model should appear mostly `Blue`. If there are any `Red` parts, they will likely need to be corrected.

![Face Orientation Overlay]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%202.png)

![Activate Face Orientation Overlay]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%205.png)

If you do have inverted normals, select the mesh, go into edit mode, select all faces, and then go to the Mesh menu, Normals, Flip Normals.

![Edit Mode]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%207.png)

![Select all]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%208.png)

![Flip Normals]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%209.png)

This video is a reasonably good guide on how to flip normals on faces inside Blender.

{% include youtube.html video="ZpK7To-YU4c" %}

[https://www.youtube.com/watch?v=ZpK7To-YU4c](https://www.youtube.com/watch?v=ZpK7To-YU4c)

### Check Bounds

Expand out the Rush Hour Advanced panel

![Expand Rush Hour Advanced Vehicle Panel]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%203.png)

Expand Rush Hour Advanced Vehicle Panel

Press `Show Bounds`

![Show Bounds]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%204.png)

Show Bounds

Your bounding boxes should be all within a reasonable volume for the car. In this example there is clearly one extending very far from the car and doesn’t make sense

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%205.png)

The common fixes for this are in this order:

1. [Apply Transforms](#apply-transforms)
2. [Check unconnected vertices](#check-unconnected-vertices)

### Check Unconnected Vertices

Click on the mesh, or the bounding box of a mesh that is at fault.

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%206.png)

In the top left of the viewport go into Edit Mode

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%207.png)

You should now see a bunch of black and yellow dots, these are the vertices. If you see any hovering away from the geometry, like below, there is a unconnected vertices.

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%208.png)

Select them with the mouse

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%209.png)

Press `del` or `delete` on your keyboard and select `Vertices`

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%2010.png)

After that, the bounding box should shrink back to normal

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%2011.png)

Go back to object mode in the top left

![Untitled]({{ site.url }}/assets/products/rushhour/documentation/blender-fixes/Untitled%2012.png)

### Clear Parents and Keep Transform

Remove any parent settings on any meshes by selecting all meshes by pressing `A` on your keyboard, then go to the `Object` menu, -> `Parent` -> `Clear and Keep Transform`

![Clear Parents and Keep Transform]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/blender-clear-parents.png)

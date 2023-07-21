---
title:  "Vehicle Model Requirements - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour, blender]
comments: true
version: 1.0
product-type: Tool
product: rushhour
---

## Vehicle Model Requirements

There are a few requirements for your vehicle before we start using the toolkit.

The addon will try and compensate for some of these problems, but it’s more reliable if you address these manually.

## Vehicle Orientation
- Ensure your vehicle is facing so the front is looking down the `+X` axis, and `+Y` is left.

![Vehicle should face forwards +X, and Left +Y]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/04-vehicleorientation.png)

## Mesh Requirements
- Ensure all your geometry parts are separate meshes
  - The wheels are required to be separate meshes from the body for rigging
  - If you are going to be using tyre deformation, or need your brake calipers to be correct you should ensure the wheels are separated appropriately.
  - Any transparent objects are separated if using nanite
  - The windows are separated by interior and exterior to avoid z-fighting issues and avoid windows drawing in the wrong order in Unreal.
- Ensure all your normals are facing the correct way with the face orientation overlay
  - [Check Normals]({% link _documentation/rushhour/82-common-blender-fixes.md %}#check-normals)
- Ensure you aren’t using negative scales on any meshes.
  - If you have negative scales, apply the transforms on the meshes
  - [Apply Transforms]({% link _documentation/rushhour/82-common-blender-fixes.md %}#apply-transforms)
- There is no parent relationship between objects, and the transforms are not relative

  

---
title:  "Preparing a Vehicle with Blender - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour, blender]
comments: true
version: 1.0
product-type: Tool
product: rushhour
---

## Blender toolkit

The Vehicle Importer is an experimental new workflow to drastically improve the time and effort involved in bringing a new vehicle into Unreal. It consists of 2 parts:

- An addon for Blender (this article)
- The importer included with Rush Hour for Unreal Engine 5.0+ (link soon)

## Template & Example Vehicles

I've provided template Blender files to demonstrate the toolkit & provide rough sizing for vehicles of the supported types. The importer currently supports 3 vehicle types:

- [Sedan](https://rushhourresources.s3.amazonaws.com/vehicles/templates/SedanTemplate.blend)
- [4x4](https://rushhourresources.s3.amazonaws.com/vehicles/templates/4x4Template.blend)
- [Box Truck](https://rushhourresources.s3.amazonaws.com/vehicles/templates/BoxTruckTemplate.blend)

## Installing the Blender Addon

The addon currently supports the 2 current LTS releases, and the latest stable release of Blender. 2.93, 3.3 & 3.5

Download the latest release from here [https://github.com/GDCorner/RushHourVehicleToolkit/releases/latest](https://github.com/GDCorner/RushHourVehicleToolkit/releases/latest)

Making sure to grab the latest `Source code (zip)` file.

Open Blender and go to Edit - > Preferences

![Open Preferences]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/00-preferences.png)

Go to the Addons Tab, and click Install in the top right

![Install addon]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/01-installaddon.png)

Navigate to where you downloaded the latest version of the addon, and click Install Addon

![Select downloaded addon]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/02-selectdownloadedaddon.png)

After it is installed, ensure it is activated by ticking the check box.

![Activate Rush Hour Unreal Vehicle Toolkit addon]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/03-activateaddon.png)

## Before your start

There are a few requirements for your vehicle before we start using the toolkit.

The addon will try and compensate for some of these problems, but it’s more reliable if you address these manually.

- Ensure your blend file filename doesn’t contain any spaces.
- Ensure your vehicle is facing so the front is looking down the `+X` axis, and `+Y` is left.

![Vehicle should face forwards +X, and Left +Y]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/04-vehicleorientation.png)

- Ensure all your geometry parts are separate meshes
  - The wheels are required to be separate meshes for rigging
  - If you are going to be using tyre deformation, or need your brake calipers to be correct you should ensure the wheels are separated appropriately.
  - Any transparent objects are separated if using nanite
  - The windows are separated by interior and exterior to avoid z-fighting issues and avoid windows drawing in the wrong order in Unreal.
- Ensure all your normals are facing the correct way with the face orientation overlay
  - Make sure all visible surfaces are blue. If they are red they won’t appear, or will appear “inside-out” in Unreal.

![Activate Face Orientation Overlay]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%205.png)

![Face Orientation Overlay in action]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%206.png)

  - If you do have inverted normals, select the mesh, go into edit mode, select all faces, and then go to the Mesh menu, Normals, Flip Normals.

![Edit Mode]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%207.png)

![Select all]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%208.png)

![Flip Normals]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%209.png)

- Ensure you aren’t using negative scales on any meshes.
  - If you have negative scales, apply the scale transform by selecting the object, and going to the object menu, Apply, Scale.

  ![Apply Scale]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2010.png)

## Preparing a vehicle

Click into your viewport and **press `N`** on your keyboard to bring up the viewport menu

![Viewport Menu]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2011.png)

Here you can see the Rush Hour Unreal Vehicle tab. Click that to show the tools

![Rush Hour Menu]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2012.png)

First, lets start by creating the necessary collections. The current templates only support 2 axles, so we’ll leave that set to **`2`**, and we’ll click **`Create Standard Collections`.**

![Create Standard Collections]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2013.png)

In your scene outliner on the right you should now see the following collections:

![Standard Collections in Outliner]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2014.png)

Now you want to drag your meshes into the appropriate collection like this example.

![Geometry sorted into collections]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2015.png)

For the wheels, the basic tyre should go in the corresponding out `wheel_x_y` collection, while the rim and brake caliper should be within the appropriate child collections.

![Wheel Collection Example]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2016.png)

You can create arbitrary sub collections under vehicle, and it will process them appropriately. Here I’ve added a booleans group so boolean meshes get centered with the vehicle appropriately so the boolean modifiers work correctly, and the group is not set to render, so these meshes themselves will not be processed for use in Unreal.

![Booleans collection]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2017.png)

You can create your own collection with any name and if it’s set to Render enabled, it will be output for use in Unreal, however the vehicle template will need to have a matching static mesh component for it to be assigned on import.

Next, we will press `Set Scene Scale`, this will ensure the scene is in the appropriate units for Unreal. If your blender scene is in the default blender scale, meshes will be appropriately resized, otherwise you will need to resize the vehicle yourself.

![Set Scene Scale]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2018.png)

Now we are going to click `Prepare Vehicle for Unreal`. This will duplicate all the meshes into a new collection called `prepped`. During this stage all transforms are applied, all modifiers are applied, all measurements are taken for wheels, and the vehicle is centered to it sits flat on the Z=0 plane.

![Prepare Vehicle for Unreal]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2019.png)

![Prepped Vehicle in Outliner]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2020.png)

The unprepped vehicle remains intact and untouched, so you may see flickering, or an offset car. This is perfectly normal, it means you can go back and make further adjustments to the original car and just press `Prepare Vehicle for Unreal` again if any changes are required. At this stage I encourage you to hide the original vehicle and inspect the new prepped vehicle for any defects, any malformed modifiers, bad UV’s, incorrect normals, etc and make any changes necessary. You can repeat this process at any time.

![Car offset when prepped due to centering]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2021.png)

If any errors come up, please see the troubleshooting at the bottom to get a clearer read out of any errors, so you can correct them before moving on.

### Rigging a vehicle for Unreal

Now the vehicle is prepped, we are ready to generate the rig, and the final meshes for Unreal.

Click the `Rig Vehicle For Export` button.

![Rig Vehicle For Export]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2022.png)

This will once again duplicate all the meshes into a new collection called `export`. I encourage you to check all these meshes again for defects before moving on.

The static meshes will all be centered around the origin at 0,0,0 so they can be attached to the bones on the Unreal side where they will retain their relative position.

#### Decimation options

The decimation options are for preparing a lighter weight skeletal mesh for the physics body tool. Typically `0.1` is a good amount for highly detailed car meshes, however for VERY detailed models you can go lower, or for instances where it’s causing too many problems, or you have low poly cars already, you can go higher or disable decimation entirely.

The skeletal mesh should be a good approximation of the vehicle and wheel shapes, without obvious holes. It doesn’t have to look perfect or smooth.

For example, this is on the minimum edge of acceptable. The wheel is still roughly the correct shape, diameter and in the right position.

![Low Res Proxy]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2023.png)

While this is too low. The wheels have not maintained an appropriate size, shape or position.

![Proxy is too low detailed]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2024.png)

If this process generates any errors, once again please skip the the Troubleshooting section at the bottom for tips and how to get a proper read out of any errors.

### Exporting the vehicle

Once the rigging process has completed and you have verified it all looks good, we can export the vehicle.

![Export Prepped Vehicle]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2025.png)

This will create a new folder beside the original `.blend` file called `export_<blend_file_name>`. This new folder will contain all the `.fbx` files, along with a `.json` manifest file which lists all the fbx files, and various vehicle properties.

Now the vehicle is prepped, we can move over to the Unreal side, and using the Import Vehicle feature of Rush Hour.

## Trouble Shooting

If you have had trouble at any step of the process so far, please keep reading, otherwise feel free to move to the instructions on the Import Vehicle

### Open the log window

The log window shows much clearer error messages. To open the log window, Go to the `Window` menu and select `Toggle System Console` which will open a new console window. This window may be behind blender, so check your task bar for it. 

![Toggle System Console]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2026.png)

![System Console / log window]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2027.png)

### Incorrect Material Assignments in Unreal

If materials are being incorrectly assigned, ensure you don’t have any blank material slots, or booleans that cause geometry to have blank or unassigned materials

![Blank material slot]({{ site.url }}/assets/products/rushhour/documentation/blenderaddon/Untitled%2028.png)

### If objects aren’t centering:

- Apply all transforms
- Don’t worry too much, there’s an additional automatic centering stage in the “prep vehicle” stage which recenters after merging meshes, adjusting origins and applying modifiers

### If you are getting bad skeletal meshes

- turn off or down decimation

### If you are getting inverted normals

- Apply all scales, and check the face orientation overlay

## Known issues

- Assigning Rush Hour materials incorrectly cleans up all newly imported textures and materials.
- Blender scene filenames can’t have periods in them
- Nanite static mesh builds can crash in some circumstances.
  - Appears to be on meshes with a large number of material slots (64 or more)
  - Potential workarounds:
    - Don’t use nanite on these meshes. Disable nanite on import and selectively enable it on valid meshes manually
    - Ensure you are using the standard collections to their fullest. The body_interior collection primarily exists to allow extra material slots on big complex vehicles.
    - Create your own template with more static mesh components that suit your needs, match these exact names with your own collections in blender.
  - Potential longer term solutions in future patches
    - Don’t enable nanite on import, check number of material slots and then enable nanite
    - Create a new default collection for body_interior
    - Longer term remedy is for the importer to detect these non-default mesh collections and automatically create the required components
- Centering vehicles doesn’t work in all circumstances.
  - Sometimes showing bounds reveals the issue
  - There’s an additional automatic centering step on Prepare Vehicle which is more reliable
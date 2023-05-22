---
title:  "Importing a Vehicle - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour, blender]
comments: true
version: 1.0
product-type: Tool
product: rushhour
youtube_id: kkanLZX6apU
---

## Importing a Vehicle with Rush Hour

The Vehicle Importer is an optional new workflow to drastically improve the time and effort involved in bringing a new vehicle into Unreal. It produces regular Chaos Vehicles. It consists of 2 parts:

- [An addon for Blender]({% link _documentation/rushhour/10-preparingavehicle.md %})
- The importer included with Rush Hour for Unreal Engine 5.0+ (this article)

Once you have prepared and exporter via the Blender addon, you can import this vehicle using Rush Hour.

## Features

- Correct handling of brake calipers
- Ability to use Nanite static meshes
- Several supported template vehicles
- Custom template vehicles
- Can be adapted to existing vehicle prep pipelines

## Open The Vehicle Import Menu

In your content browser, ensure that the "Show Plugin Content" and "Show Engine Content" options are enabled.

!['Show Plugin Content' Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/show-plugin-content.png){: .enable-lightbox}

Then, expand the Engine and Plugins directories.

![Expand Engine/Plugins Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/expand-plugins.png){: .enable-lightbox}

Scroll down and find "Rush Hour Content". Expand this and expand the Blueprints directory. I recommend right clicking Rush Hour Content and selecting "Add To Favourites" so you can quickly jump back to this folder.

![Expand 'Rush Hour Content' in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/expand-rushhour-content.png){: .enable-lightbox}

Here you will find "EUW_VehicleImporter". Right Click this and choose "Run Editor Utility Widget".

![Run EUW_VehicleImporter Widget Blueprint]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled.png){: .enable-lightbox}

You will then be presented with the Import menu.

![The Import Menu]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%201.png){: .enable-lightbox}

## Choose your options

- **Import Materials** - This imports very basic materials from the FBX files. The plugin always searches in the project for matching materials first, before then optionally importing basic materials.
- **Import Textures** - This imports textures specified in the FBX files. Can be useful if you need to recreate materials in Unreal.
- **Use Nanite** - This enables nanite on all the imported static meshes.
- **Assign Rush Hour Materials** - By default the Rush Hour plugin isn’t scanned for materials to assign. This make sure to look for matching materials in the Rush Hour plugin directory.
- **Cleanup Unused Assets** - This deletes unused materials and textures that were imported. This is experimental and may cleanup all imported materials and textures regardless of their usage. For this reason it’s disabled by default.
- **Vehicle Type** - Choose the vehicle template that closest matches the vehicle you are importing. This is just a starting point, and you are free to tweak all vehicle configuration after the fact as it’s just a regular Chaos Vehicle.

## Import the Vehicle

Once you are happy with your options, press import, and it will prompt you to select a json file. The blender addon will place all exported vehicles into a folder next to the original blend file called `export_<blend_file_name>` Open this folder and select the `JSON` file within.

![Select the exported JSON file]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%202.png){: .enable-lightbox}

This will begin the import process. You should see a progress dialog to indicate what is happening.

![The Import begins]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%203.png){: .enable-lightbox}

Once this has completed you new vehicle should be under `All -> Content -> ImportedVehicles` .

![The Newly Imported Vehicle]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%204.png){: .enable-lightbox}

## Configure Physics Asset

Navigate to your newly imported vehicle folder, and find the `PHYS_VehicleName` asset.

![Open the Physics Asset]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%205.png){: .enable-lightbox}

Open this asset and lets recreate the bodies.

![The Physics Asset Editor]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%206.png){: .enable-lightbox}

The default bodies created are not suitable for driving. We’ll quickly recreate these.

### The Body

Select the body bone on the left under Skeleton Tree

![Select the Body bone]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%207.png){: .enable-lightbox}

Now under Body Creation on the bottom left, change Primitive Type to Single Convex Hull and click Re-generate Bodies

![Choose Single Convex Hull for the Primitive Type]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%208.png){: .enable-lightbox}

The default settings will create a much better approximation of the body than the capsule, but it may still be a bit off. Feel free to increase the Max Hull Verts if you would like a more accurate representation.

![The New Body Shape]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%209.png){: .enable-lightbox}

You want to ensure this new body doesn't extend too low, especially on vehicles that already are low or have soft suspension. A body that is too low will cause the vehicle to body to collide with the ground, which will cause the vehicle to bounce around.

### The Wheels

You can all the wheels in one go. This is where the decimated proxy mesh from the Blender addon really makes a big difference and why you want the wheels to be relatively well shaped.

Select all the wheels in the Skeleton Tree

![Select all the wheel bones]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2010.png){: .enable-lightbox}

Now change the `Primitive Type` to `Sphere` and select Re-generate Bodies

![Choose Sphere for the Primitive Type]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2011.png){: .enable-lightbox}

You can see this generates much more accurate shapes for the wheels.

![Regenerated Shapes]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2012.png){: .enable-lightbox}

I encourage you at this stage to look through the `BP_<NewVehicleName>` and ensure that all materials are assigned, that there are no obvious defects in the mesh and that it looks as you would expect. Doing this now before training will save some time if you need to fix anything up.

Now you will need to train the vehicle as normal through the Vehicle Trainer.

## Integrating a custom vehicle pipeline

If you have a custom vehicle prep pipeline, you can still use the Vehicle Importer. You will need to make sure you export the vehicle in the same way as the Vehicle Importer expects. Full documentation on the expected format is coming soon. In the meantime feel free to reach out to [support@gdcorner.com](mailto:support@gdcorner.com) for more details.

## Custom Vehicle Templates

**Documentation Coming Soon**

## Troubleshooting

### General Troubleshooting

If you run into trouble, the first step should be to open the Output Log through the Window menu.

![Window -> Output Log]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2013.png){: .enable-lightbox}

![The Output Log]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2014.png){: .enable-lightbox}

This should show any error messages for issues encountered.

### Vehicle doesn’t sit on ground

Ensure you configured the Physics Asset.

### Vehicle Controls or Trains Poorly

Try lowering the `Center Of Mass Offset` on the Mesh component in the `BP_<VehicleName>` Blueprint

Open the Blueprint

![Open the Vehicle Blueprint]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2015.png){: .enable-lightbox}

If you don’t see a viewport, make sure to press `Open Full Blueprint Editor`

![Open Full Blueprint Editor]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2016.png){: .enable-lightbox}

Select the `Mesh` component

![Select the Mesh Component]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2017.png){: .enable-lightbox}

Search for `center` in the details panel on the right, and lower the Z component of the `Center Of Mass Offset`

![Center Of Mass Offset]({{ site.url }}/assets/products/rushhour/documentation/vehicleimporter/Untitled%2018.png){: .enable-lightbox}

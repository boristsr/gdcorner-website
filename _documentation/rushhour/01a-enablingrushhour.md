---
title:  "Enabling the Rush Hour Plugin - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
youtube_id: 
---

## Enabling the Plugin

If you've installed Rush Hour from the Unreal Launcher, then you will need to enable the plugin in your project. First open your project in the editor. Then go to Edit -> Plugins.

!['Show Plugin Content' Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/enablingplugin/editpluginsmenu.png){: .enable-lightbox}

From here seach for Rush Hour and tick the box. It will ask you to restart, click "Restart Now".

!['Show Plugin Content' Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/enablingplugin/rushhourpluginrestart.png){: .enable-lightbox}

## Testing the Plugin

### Finding the Content

In your content browser, ensure that the "Show Plugin Content" and "Show Engine Content" options are enabled.

!['Show Plugin Content' Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/show-plugin-content.png){: .enable-lightbox}

Then, expand the Engine and Plugins directories.

![Expand Engine/Plugins Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/expand-plugins.png){: .enable-lightbox}

Scroll down and find "Rush Hour Content". Expand this and expand the Blueprints directory. I recommend right clicking Rush Hour Content and selecting "Add To Favourites" so you can quickly jump back to this folder.

![Expand 'Rush Hour Content' in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/expand-rushhour-content.png){: .enable-lightbox}

### Loading Example Map

From the Rush Hour Content folder, expand Maps and open the Example_LongPath level.

![Load Example Map]({{ site.url }}/assets/products/rushhour/documentation/examplemap/loadexamplemap.png){: .enable-lightbox}

Select the Vehicle Animation Path actor by clicking the Rush Hour logo.

![Select the Path]({{ site.url }}/assets/products/rushhour/documentation/examplemap/selectpath.png){: .enable-lightbox}

On the right, in the details panel, scroll down and expand "Vehicle Type" and choose the BP_Sedan_RH vehicle. For UE4 it will be called `BP_Sedan_RH_PhysX` and for UE5 it will be called `BP_Sedan_RH_Chaos`.

![Select the Sedan]({{ site.url }}/assets/products/rushhour/documentation/examplemap/selectsedan.png){: .enable-lightbox}

Press Play and the vehicle should drive along the path. If the vehicle drives, Rush Hour is all ready to go!

Controls are listed in the bottom left of the viewport so you can accelerate time, change camera angle, etc.
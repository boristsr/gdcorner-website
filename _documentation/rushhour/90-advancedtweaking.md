---
title:  "Advanced AI Tweaking - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour, blender]
comments: true
version: 1.0
product-type: Tool
product: rushhour
---

## Advanced Tweaking Only - Not Usually Required

Occasionally, there are cases where you want to tweak the AI behavior in a way that is impossible with the current UI. Rush Hour tries to be as flexible as possible, while hiding the complexity of tweaking AI parameters. It is a difficult balance to provide a simple interface, while allowing in-depth tweaking for fine-grained artistic control.

For the adventurous among you, here are some notes on how to dive deep into tweaking the AI and vehicles. This article describes how to access the data tables that Rush Hour uses to store the AI parameters. The way these parameters affect driving and what variables are available may change as the driving algorithm is improved between plugin versions.

## Here Be Dragons

It's easy to mess up the driving characteristics when changing these parameters. As discussed below, you should not work on the plugin data tables but only on copies within your project folder. If anything goes wrong, you can copy the data table from the plugin again. Otherwise, you will need to reinstall the plugin to get the original data tables back.

## IMPORTANT: When Upgrading Rush Hour

- Make sure to backup the current plugin version
- Make sure to backup your changes
- If you driving behaviour is bad after updating, make sure to delete the old data tables in your project at `/Content/RushHour/Blueprints/DataTables/` and make new copies from the new plugin.

## Vehicle Performance Data

The information recorded about vehicle training and how vehicles performed is stored in a struct called UVehiclePerformanceData. The fields of the struct have relatively detailed tooltips to indicate what they are used for and how they affect driving.

![DT_VehiclePerformanceData]({{ site.url }}/assets/products/rushhour/documentation/advancedtuning/dt_vehicleperformancedata.png){: .enable-lightbox}

## Driver Profiles

The information on how each driver profile behaves is stored in a struct called UDriverProfileParameters. The fields of the struct have relatively detailed tooltips to indicate what they are used for and how they affect driving.

There are 3 custom driver profiles that you can edit without affecting the main driver profiles.

![DT_DriverProfiles]({{ site.url }}/assets/products/rushhour/documentation/advancedtuning/dt_driverprofiles.png){: .enable-lightbox}

## Data Tables Locations

The plugin supports loading data tables from 2 locations. It first tries to load the data table in your game folder. If that data table doesn't exist or if that data table doesn't contain a matching record, it will then look in the Plugin data table.

- Your game folder`/Game/RushHour/Blueprints/DataTables`

![Game Folder]({{ site.url }}/assets/products/rushhour/documentation/advancedtuning/game-datatables-folder.png){: .enable-lightbox}

- The Rush Hour plugin folder `/RushHour/Blueprints/DataTables` (Note, this may show under Engine if you have installed via the Epic Games Launcher)

![Plugin Folder]({{ site.url }}/assets/products/rushhour/documentation/advancedtuning/plugin-datatables-folder.png){: .enable-lightbox}

![Data Tables]({{ site.url }}/assets/products/rushhour/documentation/advancedtuning/plugin-datatables.png){: .enable-lightbox}

You should only work on data tables stored within your game directory. This will make it easier to upgrade the plugin without losing your changes.

Trained vehicles save into the Game version of the `DT_VehiclePerformanceData` data table. If it doesn't exist, the plugin one will first be copied to your game folder.

The driver profiles are stored in `DT_DriverProfiles` and you will need to copy it manually if you want to edit it.

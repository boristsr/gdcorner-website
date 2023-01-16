---
title:  "Training a New Vehicle - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
youtube_id: yaK5RV-H8LQ
video_out_of_date: true
---

## Training a new vehicle

The training menu guides you through the training process for new vehicles. Training is fully automated and takes around 12-13 minutes.

### Disable Use Less CPU In Background

Go to the top of the Unreal Editor window, and choose Edit -> Editor Preferences. In here search for "Use Less CPU when in Background". Uncheck this setting. This will allow training to be more reliable when switching windows.

### Open the Training Menu

In your content browser, ensure that the "Show Plugin Content" and "Show Engine Content" options are enabled.

!['Show Plugin Content' Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/show-plugin-content.png){: .enable-lightbox}

Then, expand the Engine and Plugins directories.

![Expand Engine/Plugins Option in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/expand-plugins.png){: .enable-lightbox}

Scroll down and find "Rush Hour Content". Expand this and expand the Blueprints directory. I recommend right clicking Rush Hour Content and selecting "Add To Favourites" so you can quickly jump back to this folder.

![Expand 'Rush Hour Content' in Content Browser]({{ site.url }}/assets/products/rushhour/documentation/showplugincontent/expand-rushhour-content.png){: .enable-lightbox}

Here you will find "EUW_TrainingMenu". Right Click this and choose "Run Editor Utility Widget".

![Run Training Widget]({{ site.url }}/assets/products/rushhour/documentation/trainingvehicles/run-training-widget.png){: .enable-lightbox}

This is the training menu we will use. Resize the window so you can see all the buttons, or scroll up and down to access them all.

![Training Widget]({{ site.url }}/assets/products/rushhour/documentation/trainingvehicles/training-menu.png){: .enable-lightbox}

### Load the Training Level

Click "Load Training Environment", which will create a copy of the training level in `/Content/RushHour/Maps`, and then automatically load this level.

### Select a Vehicle

Once the level is loaded, click the drop down and choose a vehicle you'd like to train.

> <span class="badge badge-info">Note</span> This drop down lists all Pawns discovered in the project, not just vehicles. Choosing an incompatible will enable the "Start Training" but training will instantly abort when you try to start training. See the output log for more details.

> <span class="badge badge-info">Note</span> Verbose Logging will output a LOT of information to the log. You should only enable this if requested to when asking for support with training. 

### Start Training

After a vehicle has been selected, the "Begin Training" will be available. This will begin the training process and take around 12-13 minutes typicaly. Some progress & status information will be displayed while the process is underway.

> <span class="badge badge-warning">Note</span> During training, if you have changed the "Use Less CPU In Background" editor setting, you can switch windows, to a web browser for instance, but do not shrink the window or do anything intensive, as the training works best when it can maintain 30 FPS.

![Training In Progress]({{ site.url }}/assets/products/rushhour/documentation/trainingvehicles/training-progress.png){: .enable-lightbox}

If, for any reason, you need to stop training you can just press "Abort Training", which will instantly end the training.

> <span class="badge badge-warning">Note</span> Make sure you use the "Abort Training" button, or the editor will remain locked to FPS for the rest of your session. Training limits the framerate to 30fps, and is restored properly when the training menu is used or training completes. Pressing the normal "Stop" button in the editor will not restore the FPS setting. You can restore full FPS by typing `t.maxfps 0` in the console.

### Saving the Results

Once training has completed, some status information will be displayed. Pressing Save "Trained Profile" will save the trained profile for this vehicle to `/Content/RushHour/Blueprints/DataTables/DT_VehiclePerformanceData`

![Training Complete]({{ site.url }}/assets/products/rushhour/documentation/trainingvehicles/training-complete.png){: .enable-lightbox}

Once saved, the newly trained profile will automatically be used for this vehicle. You don't need to change any setting on new or existing paths.

## Troubleshooting

Training has been developed to be as robust and reliable as possible, but it is possible to make vehicles that don't train well. There are various reasons. Here are a few ones to watch for, and suggestions on how to improve

### Poor performing profiles

The first thing to try if a vehicle is performing badly is to retrain the vehicle. If it trained improperly last time, I'd recommend not doing anything else on the computer. Leave the training window in focus, do not switch to another window. Just let it train with full focus. Training is limited to 30fps, but training works best when it can achieve 30fps without any stutters, hitching or slowdowns.

### Unstable Vehicles

If you watch the vehicle training and you notice it bouncing or jumping, that's indicative that the vehicle is unstable. Tweak the suspension and physics setup until it drives steady. When in doubt, reference some values from the included vehicles with Rush Hour for a starting point.

### Exceedingly slow/heavy vehicles - VehicleDidNotMove

Some vehicles, like construction vehicles with a top speed below 30mph, require full throttle to drive, which can cause Rush Hour to struggle. Increase the engine power until the vehicle drives with a much higher top speed, and then achieve the look you desire by choosing slow speeds on the animation path.

### Poor Steering Configuration - VehicleDidNotMove

Sometimes this error is triggered if the steering is reversed on a vehicle. Flip the vehicles steering setup.

### Colliding with Ground - VehicleCollidedWithGround

Vehicles can collide with the ground for a number of reasons:

- the suspension of the vehicle is too soft
- the vehicles have a lot of heavy body roll
- the collision models are too large

These factors can cause the vehicle to collide with the ground during hard turning or heavy braking. The solution is to make the suspension stronger, reduce the collision model size, or combine these.

## Known Compatibility Issues

There are a very wide range of vehicles available on the marketplace, and it's quite tricky to reliably (and quickly) train a profile for such a wide range of configurations. Here is a list of vehicles that Rush Hour is known to have problems with and some suggested changes to vehicles that will improve Rush Hour's ability to train them. Even if you don't use these vehicles, it's worth reading through as you may find similar problems with other vehicles, and these fixes will likely work too.

**This list is in no way a commentary on the quality of these products. It's just a compatibility and troubleshooting list.**

### Driveable / Animated Construction Vehicles Set [ Set of 4 ]

[https://www.unrealengine.com/marketplace/en-US/product/driveable-animated-construction-vehicles-set-set-of](https://www.unrealengine.com/marketplace/en-US/product/driveable-animated-construction-vehicles-set-set-of)

4.x/PhysX

These vehicles drive very slowly and require a very large acceleration force. I suggest giving the vehicles more torque and a much higher top speed which will allow Rush Hour to train profiles for these vehicles. You can always set the animation path to drive these vehicles slowly without limiting it in the vehicle configuration.

### Box Truck - Vehicle Variety Pack

[https://www.unrealengine.com/marketplace/en-US/product/bbcb90a03f844edbb20c8b89ee16ea32](https://www.unrealengine.com/marketplace/en-US/product/bbcb90a03f844edbb20c8b89ee16ea32)

4.x/PhysX

Only the box truck has issues in this pack. The issue stems from the fact that the vehicle naturally slows down quite a bit without braking, and the braking force is quite light. There isn't much of a window between the braking forces. I suggest making the braking force a bit stronger, which will allow more difference between not braking and braking. This will allow rush hour to train a profile for this vehicle.

### [Functional] 4 Russian Military Vehicles / 6 Versions per vehicle

[https://www.unrealengine.com/marketplace/en-US/product/functional-4-russian-military-vehicles-6-versions-per-vehicle](https://www.unrealengine.com/marketplace/en-US/product/functional-4-russian-military-vehicles-6-versions-per-vehicle)

4.x/PhysX

These vehicles have inverted steering. The blueprint configuration uses an inverse axis for steering input. Unfortunately, due to Rush Hour connecting directly to the Vehicle Movement Component, it bypasses this steering setup and the vehicle steers in the wrong direction. I plan to speak with the asset pack maker about this, in the meantime I believe the vehicles will need a new skeleton, so you can try exporting and recreating the vehicles. In the future, I may develop a solution to detect inverted steering on vehicles.

### Classic Sport Car 01

[https://www.unrealengine.com/marketplace/en-US/item/e9e10502e26946d192c243a40e258afa](https://www.unrealengine.com/marketplace/en-US/item/e9e10502e26946d192c243a40e258afa)

4.x/PhysX

This vehicle collides with the ground during cornering and hard braking. The suspension needs to be stiffened.

### RCCar

[https://unrealengine.com/marketplace/en-US/product/drivable-rc-car](https://unrealengine.com/marketplace/en-US/product/drivable-rc-car)

5.x/Chaos

Vehicle doesn't accelerate under some circumstances.

This vehicle will need some attention to identify the cause.

### Trailer - City Sample Vehicles

[https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles](https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles)

5.x/Chaos

This is a vehicle class, but it is not a drivable vehicle. It drags it's front trailer hitch on the ground. There is no need to train this vehicle. You will probably only see this as an error in batch training mode

### BP_Vehicle - City Sample Vehicles

[https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles](https://unrealengine.com/marketplace/en-US/product/city-sample-vehicles)

5.x/Chaos

This vehicle appears to just be a base class, and shouldn't be directly used. The front wheels don't even animate. This seems to train correctly in the editor, but not in batch training mode. I advise just using the other vehicles in the pack.

---
title:  "Creating an Animation - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
youtube_id: 25iUDmkg_x8
video_out_of_date: true
---

## Placing the Path

Find the actor by pressing the "Quickly Add" button in the top left. Go To All Actors and search for "vehicle".

![Find Vehicle Animation Path actor]({{ site.url }}/assets/products/rushhour/documentation/placepath/placeactor-find.png){: .enable-lightbox}

Drag the Vehicle Animation Path actor to where you'd like your path to start. Then rotate so the line is pointing in the starting direction.

![Place and Rotate]({{ site.url }}/assets/products/rushhour/documentation/placepath/placeactor-rotate.png){: .enable-lightbox}

## Extending the Path

Select the second waypoint, hold ALT, left click the transform widget, and drag forwards. This will add a new waypoint.

![Place and Rotate]({{ site.url }}/assets/products/rushhour/documentation/placepath/select-waypoint.png){: .enable-lightbox}

> <span class="badge badge-info">Note</span> Make sure you drag forwards first. If you accidentally move backwards first, you'll end up with a waypoint placed before the current waypoint, and then end up with a strange winding path.
>
> If you make this mistake, don't panic, just press "delete" on your keyboard, and drag a new point.
> 
> ![Dragging Backwards]({{ site.url }}/assets/products/rushhour/documentation/placepath/waypoint-drag-backwards.png){: .enable-lightbox}

### Altering the Curve

You can fine tune the curve of the path with the tangent line. See the fainter line and dot on either side of the selected waypoint her.

![Tangent Handle]({{ site.url }}/assets/products/rushhour/documentation/placepath/waypoint-tangent.png){: .enable-lightbox}

Grab one of those handles, and move it around. You'll see the curve change.

![Adjust Curve]({{ site.url }}/assets/products/rushhour/documentation/placepath/waypoint-tangent-curve.png){: .enable-lightbox}

## Align To Ground

Aligning To Ground is an important step in the process. Rush Hour measures ground slope at each waypoint for extra information when determining speed. Slope affects cornering and braking performance, and this is important information. It's a simple process, in the details panel on the right, just click "Align To Ground".

You should see all the points jump around 50cm off the ground (although, over elevation changes you may see the path line go through the ground). If they are still touching the ground, please see [Adjust Curve](#advanced-options) and the advanced options as described below.

![Align To Ground]({{ site.url }}/assets/products/rushhour/documentation/placepath/aligntoground.png){: .enable-lightbox}

If you find a vehicle is attacking a slope or corner too aggressively, try moving the waypoints around so they are over the most sloped portions of the track. This will help improve vehicle handling.

### Advanced Options

The align to ground default settings work well for most cases, however sometimes the points still don't hit the ground properly. Play with the following options to find what works for your path. You can see what the spline point aligned against by viewing the output log. It should list information like this for each point:

```
LogRushHour: Aligning spline point 5
LogRushHour:     Trace Up Found Actors: 1
LogRushHour:         Skipping Landscape actor: Landscape /Game/AutomotiveWinterScene/Maps/IceRoad.IceRoad:PersistentLevel.Landscape_7
LogRushHour:     Trace Down found 5 actors
LogRushHour:     Hit Actor: Landscape /Game/AutomotiveWinterScene/Maps/IceRoad.IceRoad:PersistentLevel.Landscape_7
LogRushHour: Aligning Spline Point: 5, GroundNormal: X=0.012 Y=0.011 Z=1.000, DotProduct: 0.999866
```

#### Ignore Foliage

This option will ignore InstancedFoliageActors, typically foliage placed with the foliage painter tool. This will stop paths colliding with leaves on the traces.

#### Ignore Volumes

This option will ignore Volume actors. This is useful if you have a volume to trigger an event or interact with the vehicle in some way, but you don't want the path affected by the volume. If this is off you will see the waypoints inside a volume raise ~50cm every time you press Align To Ground.

#### Ignore Triggers

This option will ignore trigger actors. This is useful if you have a trigger for an event or interact with the vehicle in some way, but you don't want the path affected by the trigger. If this is off you will see the waypoints inside a trigger raise ~50cm every time you press Align To Ground.

#### Should Trace Up

Align to Ground is a 2 stage process by default. It first traces up to ensure that it won't hit anything over the top of the path, like a bridge or a tunnel. Turning this off will skip this step.

#### Ignore Landscape in Trace Up

Sometimes the trace can hit the landscape when tracing up, which means the path will never hit the top of the road. By default it's easier to just ignore the terrain on trace up.

#### Ignore Brushes in Trace Up

Brushes can also trigger a hit in trace up, like the landscape. Turning this on may be beneficial for certain paths.

#### Actors To Ignore Up

If you have an actor that is being hit in the trace up that you want ignored and it isn't covered by the existing options, you can manually specify these actors in this array.

#### Actors To Ignore Down

If you have an actor that is being hit in the trace down that you want ignored and it isn't covered by the existing options, you can manually specify these actors in this array.

## Path Properties

Once you have your path placed, you can set up the properties for the path in the details panel on the right.

![Path Properties]({{ site.url }}/assets/products/rushhour/documentation/placepath/pathproperties.png){: .enable-lightbox}

### Auto Start

This option allows you to define whether the path should automatically start on begin play or not.

### Driver Profile

Here you can select a variety of driver profiles

* **Precision Driver** is a relatively conservative driver. This driver should not lose traction and should drive all vehicles well within control

* **Racer** is a fast, yet controller driver. This driver will push corners quite a bit faster than precision driver, accelerate faster, brake harder, and so on.

* **Frantic** is a fast, yet uncontrolled driver. This driver will push corners very fast, accelerate faster, brake harder, steer more erratically. It will also brake a lot later, often too late.

* **Sunday Driver** is a casual, controlled driver. It will accelerate a bit slower than precision driver. It produces calm driving behaviour

* **Slowpoke** is a slow, controlled driver. This driver is for doing very slow driving. It works especially well for 4x4 scenes.

#### Unused profiles

* **Custom** these profiles are there for future usage. Don't expect decent performance from them.
* **Default Driver** this profile is just a default driver profile, it's not well tuned. Don't expect decent performance from this.
* **Vehicle Training** these profiles are used for the automated vehicle training. They are configured for that purpose only.

### Profile Strength

This is an easy way to adjust performance of drivers. Technically this blends between Default Driver, and the selected profile. You can push a profile beyond it's parameters by choosing a value beyond 1.0. For example, if you choose racer with a profile strength of 1.5, it will push even faster around corners. Alternatively, you can make a profile less intense by going closer to 0.0.

### Smart Speed

Smart speed is the feature of the drivers to slow down as they approach corners. I recommend leaving this on, but if you want to tweak speeds for corners with more precision, you can turn this off and control all waypoints by hand.

### Speed Unit

If you prefer to work in MPH or KPH, this is where you can configure that. Note: this does NOT change the values set on the path or waypoints. A speed of 200 will still be 200, this will just change what that value means. 200 KPH or 200 MPH.

### Vehicle Type

This is how you choose what vehicle to spawn. It will list all pawns. If you choose an incompatible pawn it will list an error in the log when you press play.

### Vehicle to Adopt

Instead of spawning a vehicle, you can also adopt a vehicle you have placed and configured. This is useful if you have attached actors, or replaced materials on your vehicle in the level, and you don't want to spawn a new one.

It's worth noting you can specify a vehicle to adopt as well as a vehicle type. The vehicle will be adopted first, and then the path will just spawn new vehicles as specified by vehicle type when iniated by Blueprints.

## Setting Speed

Setting the speed of the path can be done on the whole path, or individually on each waypoint. The recommended workflow is to lay out the majority of your path, then do a path wide speed reset. You can then tweak speeds at individual waypoints. This minimises time spent manually tweaking.

### Whole Path Speed Reset

Expand the advanced section of the Animation Path panel. Type in a value into Reset Speed, and then press "Reset Path Speed". This will reset the values on every waypoint.

## Individual Waypoint Controls

If you select a waypoint, you can expand "Selected Points" and "Vehicle Path" in the details panel on the right and change properties.

![Waypoint Control]({{ site.url }}/assets/products/rushhour/documentation/placepath/waypoint-controls.png){: .enable-lightbox}

### Action At Point

* **Start** The vehicle will start from this point.
* **Stop** The vehicle will stop at this waypoint.
* **Continue** The vehicle will continue through this waypoint.
* **StopWaitGo** The vehicle will stop at this point, wait for the specified wait time, and then start again

### Speed

The target maximum speed at this waypoint. Smart Speed will reduce the target speed based on path curve and slope, as well as the vehicles performance characteristics.

### Wait Time

How long to wait at this point before starting.

### Stop Hardness

This is how hard the vehicle should stop at this waypoint. It's a "unitless" value, and is just a hint. Generally less than 1 will produce slow steady stops as if stopping casually at a set of traffic lights, while greater than 1 will lead to full lock ups. The harder the stop, the more likely the vehicle is to overshoot the stopping point. I plan to reduce overshoot in a future patch.

## Starting a Vehicle with Blueprints

You can start a vehicle on the path with blueprints. Here is an example of starting the vehicle on a looping timer event.

![BP Control]({{ site.url }}/assets/products/rushhour/documentation/placepath/bp-control.png){: .enable-lightbox}

## Tips & Tricks

* To maintain fast corners you want to reduce kinks and sharp turns in your path
* Using Frantic profile with a strong profile strength can produce interesting unstable driving
* Cars such as Trucks/Utes have interesting cornering behaviour as the tail slides out
---
layout: post
title:  "Turning a Mini Exercise Bike into a Virtual Bike!"
date:   2024-05-24 11:16:13 +1100
tags: [maker, telescope, 3dprinting]
comments: true
image: "/assets/posts/2024-02-20-PrintFilamentsSun/og-thumb.jpeg"
categories: blog
youtube_id: 4pHFzt2iPx4
---


This project turns a cheap exercise mini bike into a virtual bike. I made this project with my brother for a family member who has to do a few months of physical therapy. We wanted a way to motivate them to continue, and try to make it a fun game-like experience. Your pedal speed directly correlates to the play rate of the video. If you stop pedalling the “bike” will coast and slow down to a stop. If you pedal faster your video will play in fast-forward.

It consists of 2 parts. The first is a replacement for the trip computer directly on the minibike which allows us to track the pedalling motion and broadcast this information to the network. The second part is a video player on a computer that can receive these messages and play the video at the matching play rate.

Where possible we tried to use parts we already had laying around and avoid new purchases.

<!--more-->

!!! COVER IMAGE !!!

## Exploring the bike

Originally I had the idea of attaching 1 or more magnets and using a hall effect sensor to monitor the rotation speed of the bike that way, but when I pulled off the trip computer to look how it works I noticed on the internal wheel there was already a magnet attached. Looking at the trip computer there was a tube that sits next to the magnet. Pulling this off and checking it on a multimeter in continuity test mode showed that it’s just a magnetic switch. This meant that I could use the existing mechanism, and we could just rebuild the housing and put in the custom trip computer.

!!!!!!!!!!!!!!!!!!!!IMAGES!!!!!!!!!!!!!!!!!!!
The small silver circle you can see is a magnet on the internal wheel.
!!!!!!!!!!!!!!!!!!!!IMAGES!!!!!!!!!!!!!!!!!!!

## Designing the case
My brother was in charge of the case. The first order of business was to match the socket the original computer sits in. This meant that mounting the trip computer is very easy and requires no modification to the main bike casing.

The original goal was to be as small as possible, but this ended up being quite frustrating to iterate on. The final design ends up quite bulky, but fits neatly on the bike and doesn’t get in the way of the rider. To help with durability as we iterated the build he used heat-press inserts which make it so screws don’t damage the plastic on repeated assembly

The final design is easy to print, easy to work in and easy to assemble.

!!!!!!!!!!!!!!!!!!!!IMAGES!!!!!!!!!!!!!!!!!!!

## Designing the Trip Computer

One goal was that we could build this with parts we had laying around. The [TTGO T-Display](https://www.lilygo.cc/products/lilygo%C2%AE-ttgo-t-display-1-14-inch-lcd-esp32-control-board) is cheap and has an integrated screen. It has way more than enough grunt to handle a simple trip computer display.

The magnetic switch from the original trip computer could be used directly with the microcontroller pins, just setting one to INPUT_PULLUP so it could use the internal pullup resistor.

For power, I’m still beginning with the world of microcontrollers and electronics and I don’t trust myself with lithium batteries, so instead I chose to use a 9v battery and a buck converter. The buck converter used can take a wide range of inputs and has an adjustable output voltage. Your input voltage must be a bit higher than your output voltage, so being that we needed 5v out, 9v in seemed appropriate and meant that it was only one battery at a time.

When powering the adjusting the output voltage 5.0v seemed to work but the WiFi was unstable. Bumping the output voltage to 5.1v solved the problem.

The prototyping PCB and the headers aren’t strictly necessary but it gave good mounting options in the case, and made it really easy to replace the T-Display when I accidentally fried one. **Note: DO NOT CONNECT BATTERY AND USB AT THE SAME TIME!**

!!!!!!!!!!!!!!!!!!!!IMAGES!!!!!!!!!!!!!!!!!!!

## Designing the software

I wanted to use this project to experiment with [LVGL](https://lvgl.io/) which is a really interesting GUI library for embedded systems.

I wanted the setup process to be dead simple for the rider. By just relying on UDP broadcasts it meant that the laptop and trip computer just needed to be connected to the same WiFi network, and there was no pairing required. The trip computer just broadcasts a packet containing a few characters to confirm it’s packet type, a packet ID which is incremented on every broadcasted packet, and the number of cycles counted so far. The video player then only processes packets that have a higher ID than the previously received one, so there are no concerns with out-of-order packet delivery.

There are no IPs hardcoded into the microcontroller, it just assumes that you are on a standard /24 network with the broadcast address being x.x.x.255. It takes the current IP obtained via DHCP and replaces the final octet with 255. This means that on basically any home network it will broadcast the packets to all PCs. PCs that aren’t listening for the packets will just discard it.

For the video player on the laptop I just used the old faithfuls of [Python](https://www.python.org/), [PyGame](https://www.pygame.org/) and [OpenCV](https://opencv.org/). PyGame is used for the presentation of the video, and [OpenCV](https://opencv.org/) is used for its [FFMpeg](https://ffmpeg.org/) integration allowing decoding of all sorts of videos. I did hardcode some limits into the player, the player expects 720p videos, but supports any FPS (tested with 30 and 60fps), and codecs don’t seem to be too picky. I tested with h264 and h265 videos.

For every pedal received it bumps the target playrate up. The target playrate is decayed over time towards zero. The actual playrate is then slowly adjusted over time towards the target playrate which gives a much smoother, more naturally changing video playback speed. This means adjustments are not jerky, and it gives that "coasting to slow down" effect.

The circles on the right side of the screen show the play rate. The green circle is the target of 1x speed playback, and the red circle is the current play rate. These were initially added as a debug view however they ended up being a nice visual feedback for the rider, so they stayed!

I didn’t want the rider to mess about with python, or have complicated running instructions. To achieve this the whole thing is turned into a simple to run .exe with [PyInstaller](https://pyinstaller.org/).

I’m happy with the results of the software, it has enough features implemented to be a good experience, and there are no super rough edges, or complicated setup required to do a bike ride. Having said that, I didn’t want the software to become a multi-weekend time-sink, so the code quality reflects the “maker” nature of the project.

## Finding videos

There are a huge number of creators on YouTube who do walking tours of picturesque or historic places, some favourites are [Follow Matty](https://www.youtube.com/@FollowMatty) and [Dave's Walks](https://www.youtube.com/@DavesWalks). I downloaded some videos of areas of sentimental meaning to my family member using [YT-DLP](https://github.com/yt-dlp/yt-dlp) and converted them with [Handbrake](https://handbrake.fr/) to 720p, h265, CRF29, leaving the frame rate the same as the original, using constant framerate, not variable framerate. This meant that the videos are reasonably good quality while not taking up a huge amount of space. Most of the quality loss is not important since the screen is a bit of a distance away and while pedalling you are rocking a little bit.

## Power Reduction

A few weeks after giving the gift I noticed the battery went dead a lot sooner than I’d have liked. I thought of a few improvements to reduce power consumption including looking into WiFi powerstates, MCU powerstates, and reducing the backlight brightness. In the end I settled on just reducing the clock speed of the microcontroller from the default 240 mhz to 60 mhz which resulted in bringing the power consumption from around 83mA to 73mA, which is pretty decent for such a small change. The code for the trip computer really doesn’t do much so I would have liked to go down much lower, but I found the screen would not reliably turn on or initialise at lower clock speeds.

On the T-Display there doesn’t appear to be direct display brightness control, but it does seem you can control the light through one of the GPIO pins. I’d be interested to see if you can control the brightness via PWM this way, but didn’t have a chance to test this.

## Builds 2 and 3

After seeing the finished project my brother and a friend wanted to build the project for themselves, so we found the bike online and ordered a few more. We were able to build the project again twice within a few hours, so it’s not an overly complicated project to replicate.

## Build Instructions

Code: [https://github.com/boristsr/VirtualBikeRides](https://github.com/boristsr/VirtualBikeRides)

Prints: [https://www.printables.com/model/875892-mini-exercise-bike-esp32-virtual-convertion](https://www.printables.com/model/875892-mini-exercise-bike-esp32-virtual-convertion)

Parts (All prices in Australian Dollars - AUD):

| **Item Name**                                                                  | **Model Number** | **Qty** | **Price**   |
|--------------------------------------------------------------------------------|------------------|---------|-------------|
| [DC-DC Supply Module LM2596 Buck Converter](https://www.amazon.com.au/Supply-Converter-Adjustable-Step-Down-1-5-35V/dp/B0BCGXZBQ9/ref=sr_1_5)                                      | LM2596 DC-DC     |       1 |       $5.77 |
| [LILYGO® T-Display ESP32 Dev Board, 1.14 Inch LCD, WiFi/Bluetooth, Flash 4MB](https://www.lilygo.cc/products/lilygo%C2%AE-ttgo-t-display-1-14-inch-lcd-esp32-control-board)    | T-Display v1.1   |       1 |      $18.00 |
| [ElectroCookie Mini PCB Prototype Board Solderable Breadboard](https://www.amazon.com.au/Solderable-Breadboard-Electronics-Gold-Plated-Multicolor/dp/B081MSKJJX/ref=sr_1_3)                   |                  |       1 |       $2.17 |
| 2.1 JST Connector                                                              |                  |       1 |             |
| [Male 2.54mm Bent Pin Header Right Angle Single Row 90 Degrees Needle Connector](https://www.aliexpress.com/i/1005003646655689.html) |                  |       1 |             |
| 9V Battery Connector                                                           |                  |       1 |             |
| 9V Battery                                                                     |                  |       1 |       $2.49 |
| [Round Rocker Switch with LED Indication Red 20A 12V](https://www.boataccessoriesaustralia.com.au/round-rocker-switch-with-led-indication-red-20a-12)                            | QY802-101        |       1 |       $6.25 |
| [Verpeak Mini Pedal Bike with LCD Display](https://www.amazon.com.au/Verpeak-Mini-Pedal-Bike-Display/dp/B0C1JT2SY2/ref=sr_1_7)                                       |                  |       1 |      $67.95 |
| Wire, M3 screws, filament, heat press inserts, odds and ends                   |                  |         |             |
|                                                                                |                  |         |             |
|                                                                                |                  |         |             |
| Total                                                                          |                  |         | $102.62 AUD |
|                                                                                |                  |         | ~$70 USD |

### Assembly Instructions

1. Print the case from Printables
1. Optionally press in Heat Press Inserts
1. Assemble the electronics as shown in diagram below
    1. Adjust the LM2596 voltage regulator to 5.1v before connecting to the T-Display
    1. Put kapton or electrical tape over the regulator adjustment afterwards to ensure it doesn’t get changed during assembly
    1. Make sure the magnetic switch is connected to GPIO 21 (labelled 21 on my T-Display board)
    1. Optionally add a drop of hot glue on all soldered wire joints to reduce strain on these joints if you are iterating the design a bunch.
    1. I only had 10 pin female headers so I offset them diagonally to better support the T-Display board
    1. We have assembled 3 of these now, some of the original trip computers had a JST connector to disconnect the magnetic switch, some we had to cut the wires and add our own JST connector.
1. Flash the firmware to the T-Display as the USB port will be inaccessible once in the case
1. You can test the firmware by running a magnet past the switch/probe before assembly
1. Install into case as shown in picture
1. Put kapton tape over anything you fear might short, such as over the switch where the battery will sit below.
1. Make sure you mount the magnetic switch as low as possible in the case so it is as close as possible to the magnet on the internal resistance wheel of the bike. You may need to test this a few times to get it right. Spin the pedals and see if the counter goes up on the screen.

!!!!!!!!!!!!!!!!!!!!IMAGES!!!!!!!!!!!!!!!!!!!

### Connections:

1. Battery +9v to switch
1. Switch to LM2596 IN+
1. LM2596 OUT+ to TDisplay +5v (Pin 1)
1. TDisplay GND to LM2596 OUT-
1. LM2596 IN- to Battery Ground
1. TDisplay GPIO 21 to magnetic switch
1. TDisplay GND to magnetic switch

### Software

For deployment instructions on the software, I’ve included them in the repository linked at the start of the build instructions.

## Adapting to Other Bikes

If you are doing this on another bike, I’d look into replacing the magnetic switch with a hall effect sensor, and attaching a magnet or a few magnets to something that rotates with the pedals so you can do very similar tracking. Having more than 1 magnet per rotation will require additional code modifications but should allow a more fine grained estimation of the RPM being pedalled.

## Future work, improvements and expansions
There are plenty of ways to improve this project and take it forward. Maybe in the future I’ll implement some of them. Sharing these ideas in case anyone would like to improve their own build.

- Reduce power consumption
    - WiFi power state
    - MCU sleep states
    - Display brightness
- Rechargeable battery
- Battery charge percent monitor
    - Add a simple voltage divider and an ADC to monitor battery remaining
- Screwless battery compartment hatch
- Smaller housing
    - Pack components tighter and reduce overall size
- Better WiFi configuration
    - The credentials are hardcoded in the trip computer code. I’d like to utilise some of those projects where the MCU becomes a hotspot that allows you to configure WiFi from your phone if it can’t find the existing configured network.
- Player improvements
    - UI
    - One button adjustment to target pedalling speed
    - Support other resolutions than 720p
    - Sound playback
    - Either pitch shifting sound, or looping sound in 1 minute blocks
    - “Buffering” mode
    - The rider is required to pedal enough to maintain a buffer, if the “buffer” runs out the video pauses until the rider has pedalled enough to restore a healthy buffer. Just like the old days of the internet!
    - Interval training mode
    - Alternate the target play rate through a guided series of high and low intensity periods.
- Unreal Experience
    - I’d love to make a compatible Unreal Engine experience where the pedal speed just controls the speed moving along a spline through a great looking environment. I chose videos for this project mainly for the areas which have some sentimental meaning for the rider. An unreal experience wouldn’t be too hard.




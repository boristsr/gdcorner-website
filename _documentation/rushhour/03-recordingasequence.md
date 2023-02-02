---
title:  "Recording A Sequence - Rush Hour"
tags: [unreal, unrealengine, ue4, ue5, tool, vehicles, animation, cars, animation, rushhour]
comments: true
version: 1.0
product-type: Tool
product: rushhour
youtube_id: K2n1PIUMLjw
video_out_of_date: true
---

## Recording to a Sequence

Recording a vehicle to a sequence can help your workflow for producing final animations. The main benefits are:

* Perfect repeatability
* Ability to scrub through the animation in sequencer
* Ability to layer effects and camera cuts in reliably.

## Limitations

* Currently light state is not recorded by sequence recorder or take recorder. I'm investigating an approach that will enable this to work.

## More Information on Take Recorder

This is not a complete guide on Take Recorder, but rather a quick start which you can use to dive in the deep end. For more information on Take Recorder and Sequencer I recommend the official documentation.

[Take Recorder in Unreal engine](https://docs.unrealengine.com/5.0/en-US/take-recorder-in-unreal-engine/)

[Using Take Recorder](https://docs.unrealengine.com/5.0/en-US/record-gameplay-in-unreal-engine/)

## Sequence Recorder vs Take Recorder

Take Recorder is the new method for recording actors to a sequence moving forward with newer version of Unreal Engine, but sequence recorder also works. These instructions are for Take Recorder, but it's a very similar process for Sequence Recorder.

## Enable Take Recorder Plugin

Go to Edit -> Plugins, search for Take Recorder, tick enable. It will prompt you to restart your project, click Restart, and continue on once the project is reloaded.

## Recording with Take Recorder

Open Take Recorder by going to Window -> Cinematics -> Take Recorder.

![Open Take Recorder]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/opentakerecorder.png){: .enable-lightbox}

Play and Pause your play-in-editor session so the vehicle is spawned but hasn't yet driven off.

![Press Play for Play In Editor]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/press-play-pie.png){: .enable-lightbox}

![Press Pause for Play In Editor]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/press-pause-pie.png){: .enable-lightbox}

In Take Recorder, click "Source" -> From Actor -> Choose the actor you wish to track. In this case I'm choosing BP_Sedan_RH_Chaos.

![Add Actor as Source]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/track-vehicle-actor.png){: .enable-lightbox}

Select the actor source, and then scroll down and uncheck "Remove Root Animation". If you forget to do this you may find some meshes are in the wrong location, like windows hovering above the car.

![Uncheck Remove Root Animation]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/disable-remove-root-motion.png){: .enable-lightbox}

Press Record and wait for the timer to count down, then press Resume play in the editor.

![Press Record]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/press-record.png){: .enable-lightbox}

![Wait For Timer]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/wait-for-timer.png){: .enable-lightbox}

![Press Resume for Play In Editor]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/press-resume-pie.png){: .enable-lightbox}

## Disable Simulate Physics on Recorded Actor Skeletal Mesh

Once the recording has taken place, the sequence will work fine when scrubbing through, but when you try and play in Movie Render Queue or at runtime, some meshes will remain in place, and some weird collisions can happen. To fix this you need to disable Simulate Physics on the recorded skeletal mesh.

Open The Sequence you just recorded.

![Open the Recorded Sequence]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/open-recorded-sequence.png){: .enable-lightbox}

Find the Actor & Skeletal Mesh

![Find the Actor and the Skeletal Mesh]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/find-skeletal-mesh.png){: .enable-lightbox}

Select the main skeletal mesh, and in the details panel on the right search for and disable Simulate Physics.

![Disable Simulate Physics]({{ site.url }}/assets/products/rushhour/documentation/recordingasequence/takerecorder/disable-simulate-physics.png){: .enable-lightbox}

## General Tips for best results

1) Before Recording, Turn Scalability to Low, and reduce anything that may cause a performance drop or a hitch. Any hitches will be recorded into the final sequence.
2) After Recording, Ensure you have disabled "Simulate Physics" on the vehicles skeletal mesh, or it may appear fine in the editor, but fail to render correctly in the Movie Render Queue, or when played as a sequence in game.
3) Before rendering, disable Auto Start on the Vehicle Animation Path you recorded the sequence from. If you don't the path will attempt to spawn a vehicle on top of your recorded vehicle and they will collide.
4) Before rendering, turn off any systems that will cause randomness in your world, such as the traffic spawner in the City Sample project. These systems don't repeat the same way, so between renders you may have cars in the way of your car, or camera which were not expected.

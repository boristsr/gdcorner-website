---
layout: post
title:  "Leaning in Games With Your Webcam"
date:   2020-07-11 11:17:13 +1100
tags: [Development, python, opencv, poc]
ogimage: "/assets/posts/2020-07-11-WebcamAsGameInput.md/ogimage2.png"
comments: true
permalink: /2020/07/11/WebcamAsGameInput.html
categories: blog
---

I’ve always found using Q and E to lean in FPS games awkward. I just don’t have the coordination to maintain strafing and normal movement with WASD while also using those keys. I wanted to see how difficult it would be to use my webcam to detect head tilt and translate that into in-game actions.

<!--more-->

I’ve hastily slapped together a proof of concept, imaginatively called FaceLean, and it works surprisingly well. It’s definitely a bit of fun in single player games. See the video below.

<div class="embedvideo">
<iframe width="100%" height="100%" src="https://www.youtube.com/embed/_NggXhsWcak" frameborder="0" allow="accelerometer; autoplay; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>
</div>

Latency isn’t perfect and it’s only sampling at 30hz, depending on your webcam. I’ve added some hard coded delays to stop it constantly firing events when you are hovering on the threshold angle. I haven’t been brave enough to test it online, as I don’t want to upset anti-cheat software and risk my steam account or a hardware ban.

It’s definitely only POC quality. It’s slapped together using a portion of this [example from TowardsDataScience](https://towardsdatascience.com/precise-face-alignment-with-opencv-dlib-e6c8acead262) to learn how to use the dlib facial recognition model. With this it's easy to extract the 2 eye locations. With those locations I can calculate a vector between the eyes then calculate a dot product with a horizontal vector.

## Future work / Known Issues

There are 3 main issues at the moment.

### Undesired input when not in a game

Ideally, this would detect when a game is loaded and only send input events then. This would stop stray characters being put into text documents and chats. This could also reduce background CPU usage.

### Stuck leaning

In my experience with ARMA 3 if you start or stop leaning when performing an action in game that prevents you leaning, then the game gets out of sync. Leaning again resolves this. I’m not sure how to cleanly solve this apart from repeatedly firing events. This isn’t a great solution as I fear it may contribute to triggering anti-cheat software. Ideally integration with games would be able to trigger events directly, rather than through simulated key presses.

### Latency

Without dedicated hardware designed for high-fps and low-latency video streaming I doubt there is much that can be done about this. It’ll never be at the same level as a purpose built low-latency solution.

## Where can I get it

<span class="badge badge-danger">DANGER</span> DO NOT USE THIS IN ONLINE/MULTIPLAYER GAMES! I have no idea if simulated key presses will trigger anti-cheat detection, best to avoid it altogether and only use this in single player games.

### Repo

[https://github.com/boristsr/FaceLean](https://github.com/boristsr/FaceLean)

### Main tech used

* [Python](https://www.python.org/)
* [NumPy](https://numpy.org/)
* [OpenCV](https://opencv.org/)
* [DLib](http://dlib.net/)

### Requirements & installation

Ensure you have the following software installed

* CMake (latest)
* Visual Studio Community or Professional (I used 2019)
* Python 3.7 or greater

Download or clone the repo.

Run the following command to install other requirements

```bash
pip install -r requirements.txt
```

Download and extract shape_predictor_5_face_landmarks.dat from [https://github.com/davisking/dlib-models/blob/master/shape_predictor_5_face_landmarks.dat.bz2](https://github.com/davisking/dlib-models/blob/master/shape_predictor_5_face_landmarks.dat.bz2) into the project directory

Then run main.py

```bash
python main.py
```

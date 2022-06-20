---
layout: post
title:  "Why Doesn't Camouflage Work in Games? - Ask A Game Dev"
date:   2021-05-07 14:16:13 +1100
image: "/assets/posts/2021-05-07-CamouflageInGames/ogimage.jpg"
tags: [essay, gamedev, camouflage, unreal, ue4, tutorial]
comments: true
transcription: true
categories: blog
youtube_id: nheFNQs378s
---

Have you looked at camouflage in games recently? It looks amazing. Yet, it doesn't seem to stop you being seen in a split second. Is that a limitation of the technology or is it by design?  Let's have a look at some of the techniques and try recreating some of the ways game developers make camouflage look really good while still allowing easy visibility of characters.

<!--more-->

First let's break down what real camouflage is and how it works. Camouflage is used to hide what you don't want seen. In world war two German forces painted their bunkers and fortifications, in Normandy with skies and fences. Modern soldiers were all kinds of patents on their clothes and even paint their rifles.

How does real camouflage work? One of the key aspects of camouflage is to break up any identifiable pattern, outline or silhouette of what you're trying to hide. Camouflage will use three primary techniques for this.

The first is matching color to the environment. Armies use various sets of outfits and shades of greens and Browns to match forest, bush and desert environments for instance.

The second is using patterns to trick the eye into not recognizing any outline or shape. This is the typical blob, leaf and digital patterns that you see on camouflage.

And the third technique is changing the silhouette with nets and other coverings.  This is why you see snipers covering themselves in netting and shrubs.

So how do games make camouflage less effective? Game designers, artists and developers have many tricks up their sleeves to keep camouflage looking great while making it bad at hiding players. Let's have a look at some of these.

There are some clearer examples of how this was done. CS:GO uses high detail players with relatively low detailed backgrounds, which provides a clear contrast. Look at the environment around the players, in these clips. While there's a lot of detail to these environment, great care has been taken to ensure that there isn't a lot of high contrast or high-frequency detail on the walls and textures that'll break up any character silhouettes.

Paying careful attention to character silhouettes is just as important in semi realistic games as it is in fantasy games. For instance, an easy win in world war two games is that the helmets were distinctive designs and can provide clues to the players when observing just the character silhouettes.

Beyond these art decisions and directions, there are a number of lighting, texturing and shading techniques that can be used.

Let's look at a scene with relatively effective camouflage and implement some of these techniques to reveal the characters. I've grabbed two assets off the Unreal Marketplace for this. The first is G Soldier With Gas Mask by TalkingDrums and Forest - Environment Set by NatureManufacture.

In this first example, I've placed three soldiers in the scene. I've changed the tactical gear that the soldiers are wearing to use a camouflage pattern. Have a go at spotting all three.

Here's the scene again, pointing them out. While it's not impossible to spot the characters, they're mostly in the open and they still don't jump out to the player. If you were running through this environment, concentrating on the next objective or looting, it'd be easy to miss these threats. Especially if they tried hiding better.

Now that we have a scene where we can see effective camouflage in action, we can start experimenting with techniques we often see in games. First, let's see the obvious. If you change the tactical gear on soldiers to be a solid color, it won't seem out of place. We aren't surprised to see black tactical gear in use, even if it's not strictly realistic in all situations. This provides more recognizable features and strong bands of contrast to look out for.  As I mentioned earlier, soldiers will even paint their rifles to hide obvious shapes and bands of contrast from sticking out. This technique is relatively effective while not immediately destroying any realistic art style of a game.

Now let's move on to the next technique: lighting. Look at this clip from Battlefield Five. Let's freeze frame here. Look at the specular highlights on the rifle, the lighting on that grain silo. As you can see the main light in the scene is coming from the left. Now let's look at these soldiers. They're being lit from the right. There's a strong edge light effect on them, which makes it really easy to see their profiles.

You can achieve this in many ways in most engines, but let's replicate it using one method in unreal.

If we find our soldier in the scene and scroll down to lighting channels, by default all objects and unreal are affected by lights and channel zero. We're going to select these soldiers and set them to be affected by lights in channel one, as well as channel zero.

Now let's place a second directional light.   Let's move it around and angle it so opposes the main scene light. Now let's turn off channel zero and turn on channel one.   We'll also turn off cast shadows, which will save performance, But it will also increase the strength of the effect. As you can see both legs show up with an edge highlight rather than one leg being shadowed by another.

These characters now have a strong edge light, which really separates them from the background.  This is probably the most effective change we've made to player a visibility.

If we really wanted to push the visibility of players, we can add a more pronounced silhouette. We'll do this by adding a fresnel effect to the shader.   A Fresnel effect will be black when the surface is facing the camera directly, but as the surface angles away, the fresnel term increases in value.  On this sphere, you can see it's black in the center and fades to white at the edges. With this, we can do a few things.   We'll darken the base color, and we'll also use it to increase the roughness of the players. So they get a more pronounced dark edge. This is quite an extreme example, but you can see the edges a little bit more clearly on the soldiers now.

For this video. I've used quite strong versions of these effects to demonstrate them. In reality, you'd mix some combination of these, you'd balance the brightness of the light, the strength of the fresnel effect and adjust the colors on the tactical gear to a point that fits the needs and art style of your game. Many of these effects can be mixed and subtle enough that for many players it'll be almost subconscious and won't kill the realism of the characters or the environment. Clearly, it's not all physically accurate, but the effects aren't changing the art style and making it cartoony.  Many players probably can't even tell you what effects are being used, but they'll still benefit from the improved visibility.

In many older games, some of this was almost free as it was harder to match players to their environment due to the level of detail difference as well as the different lighting techniques that were used. As rendering performance has increased and environment detail has gone up, it's even more important to spend time making sure that the characters look great while remaining visible to players.  These are just some of the techniques that can be used to separate a character from the environment.
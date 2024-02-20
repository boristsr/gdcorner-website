---
layout: post
title:  "How Does Color Affect 3D Printer Filament Strength In The Sun?"
date:   2024-02-20 14:16:13 +1100
tags: [maker, telescope, 3dprinting]
comments: true
image: "/assets/posts/2024-02-20-PrintFilamentsSun/og-thumb.jpeg"
categories: blog
---

I wanted to deep dive into choosing the correct 3D print filament for my telescope project. In todays post I show how print color affects the strength of 3D prints in sunlight, and how PETG isn't always a safe bet.

<!--more-->

One October day, Spring in Australia, I was preparing the aluminium base plate of my new telescope project. I took out all the tools including the drill, the rotary tool, and the black plastic PLA template out to the garden. I turned around for what felt like just a minute to unfold the work table and when I turned back around I was shocked to see the template had warped and bubbled, and it stretched like rubber when I tried to pick it up.

![Warped Base Plate](/assets/posts/2024-02-20-PrintFilamentsSun/warped-baseplate.jpeg){: .enable-lightbox}

This was BAD. It wasn’t a particular hot or intense sunlight day. This meant I couldn’t leave my telescope out overnight in case it was in the sun for just a fraction too long in the morning. 

I had done some research, and apparently PLA is not recommended for being in the sun. PETG is apparently the go-to option for outdoor prints. I thought this was fine since the telescope wasn’t intended to be left out in the open all day, and I had plenty of PLA, it was cheap, and printed very easily and reliably. Though, I did want to leave it out overnight and pack it away in the morning without fear of a little sunlight. I figured it’d be fine for just a few morning hours here and there. After this experience though, I wanted to dive a bit deeper, and find a suitable material replacement.

## Plastics and Glass Points

Each plastic has a different temperature for it’s “Glass Point”. This is the temperature when the plastic begins to lose it’s strength and becomes malleable. The plastic becomes easy to permanently deform, bend and warp.

[For PETG this is supposedly 80ish Degrees Celsius. PLA is much lower at 60-65C degrees.](https://3dsolved.com/3d-filament-glass-transition-temperatures/)

## Reflectivity, Absorption and Colour

I had originally chosen black filament for the telescope with the idea it would reflect less and possibly leak less light so the telescope platform itself would have less chance of impacting the images.

The colour of an object is a huge factor in how much it’ll heat up in the sun. Basically, the darker an object the less energy and light it reflects, and the more it absorbs. It’s the opposite for lighter colours, by reflecting more energy it is absorbing less. A great deal of the heat energy that we receive from the sun is in the IR and visible light spectrum.

![alt text](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled.png){: .enable-lightbox}

[Source: https://en.wikipedia.org/wiki/Sunlight](https://en.wikipedia.org/wiki/Sunlight)

This means that the colour of the filament should greatly affect it’s performance in the sunlight, so I decided to get a little more scientific in choosing my filaments.

## The Plan

I had kept all my test prints, iterations and templates for the base of my telescope so I had plenty of PLA prints to test with, which would reduce plastic waste from this experiment. But I did need to print some PETG samples to test with. All I had was some pink PETG, so this was the first test. Unfortunately I didn’t get any temperature readings on this, but it was left in the sun, upright, for 2 days. This is the worst case for the filament. It didn’t deform in any obvious ways. There was a small crack in it, but I suspect this was probably more wind due to how it was held upright.

![Pink PETG sample](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled.jpeg){: .enable-lightbox}

This was a promising result, but it is a fairly light colour, so the result can’t entirely be attributed to the plastic type.

Next I painted the 2 pink PETG samples, and 2 black PLA previous iterations. One of each was black and white. The coat was thick enough to hide the filament colour, but not too thick where it might add much strength. They were painted on an overcast afternoon/evening so they didn’t get any direct sun exposure before testing.

![Painted PETG samples](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-1.jpeg){: .enable-lightbox}

Painted PETG samples

![Painted PLA samples](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-2.jpeg){: .enable-lightbox}

Painted PLA samples

![IR Security Camera Appearance](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-1.png){: .enable-lightbox}

Checking these out on my security camera at night showed that they were also appropriately dark and bright under the near-IR spectrum. I am going to assume this holds further into the IR spectrum too.

Now the test begins. I setup the painted PETG samples on a chair in the sun. It was a ~32C degree day with intermittent cloud cover. The prints were placed to overhang the edge to produce some load on the plastic.

![From left to right: Black painted PETG, White painted PETG, unpainted black PLA](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-3.jpeg){: .enable-lightbox}

From left to right: Black painted PETG, White painted PETG, unpainted black PLA

![Painted PLA samples in the sun](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-4.jpeg){: .enable-lightbox}

On a separate chair I placed the white and black painted PLA samples over an old 2x4. A similar level of overhang to produce similar loading.

The results didn’t take long. In minutes it was apparent that even black PETG wasn’t up to the task.

![PETG Begins to sag](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-1-1.jpeg){: .enable-lightbox}

The white PETG sample here looks bent, but that was the crack i mentioned earlier. It did not deform at all under the sun.

![Unpainted PLA stands no hope](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-5.jpeg){: .enable-lightbox}

The unpainted black PLA performed even worse. Not just sagging, but getting that same “bubbly” sort of shape as the first accident.

![Painted PLA](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-1-2.jpeg){: .enable-lightbox}

The painted PLA here performed about the same. Not just sagging, but getting a twisty/curvy look which I’m guessing is from that bubbling deformation mixed with the paint creating an extra tension.

When in direct sunlight for a few minutes you could feel the black prints all felt a bit soft, rubbery. They would stretch with your hand.

In both cases, however, the white painted samples performed great. Even after several hours they felt strong, didn’t feel at all weaker. They never sagged.

![PETG continues to sag](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-6.jpeg){: .enable-lightbox}

Over the course of the next few hours the PETG continued to sag.

I took an infrared thermometer out to see just how much the colour was affecting the temperature of the prints.

![Infrared Thermometer reading 73 degrees celsius](/assets/posts/2024-02-20-PrintFilamentsSun/Untitled-1-3.jpeg){: .enable-lightbox}

Unfortunately the LCD was hard to show in photos in the sunlight.

All the black prints were in the 70-75C (158-167f) degree range when in sunlight. This depended on the cloud cover, how long direct sunlight had been on them, and where I measured, but it was pretty consistent under full sun.

The white prints however, were ALWAYS under 50C (122f). There was 1 reading at 49C (118.4f) degrees, but for the most part were in the 40-45C (104-113f) degree range. This is significantly lower than the glass point of even the PLA filament. That’s a difference of 30C (50f) degrees! That’s huge! Just from a colour change.

To further highlight the difference it can be useful to not just directly compare the absolute temperatures, but also the temperature over ambient. In this case the white prints were about 10C degrees above ambient temperature, while the black printers were 40C degrees over ambient! This means that the black samples absorbed 4 times the energy!

[More info on heat transfer and temperature change](https://phys.libretexts.org/Bookshelves/College_Physics/College_Physics_1e_(OpenStax)/14%3A_Heat_and_Heat_Transfer_Methods/14.02%3A_Temperature_Change_and_Heat_Capacity)

## Long Term UV Damage

This test obviously only tested the strength of the filament due to temperature changes from sunlight, in the long term you’ll also have UV radiation aging and degrading the plastic, as well as fading colours. This is a separate problem, and I suspect both filaments would be damaged by this, although PETG is reportedly significantly more UV resistant. A coating of paint, especially a paint designed for exterior use, would help significantly for protection against UV in any case.

[More info on UV resistance](https://www.filamentive.com/best-3d-printing-filament-for-outdoors-uv-resistance-guide/)

## Conclusion

While the advice online is to use PETG for outside prints, It’s quite clear that just blindly or randomly choosing PETG isn’t a guaranteed safe bet. Poor choice of colors can lead to PETG prints sagging and weakening in the sun as the colour of an object has a huge impact on it’s absorption of radiation in the IR and visible spectrums.

Choosing white or lighter colours of filament can significantly improve the strength and durability of your prints in sunlight. Here the difference was 10C degrees over ambient vs 40C degrees over ambient. The darker colours will absorb so much energy in hotter weather with intense sun that even recommended filaments like PETG will lose their strength. On the other hand using lighter colours means even PLA can perform pretty well. Although it appears PETG may provide a little more breathing room due to the higher glass point temperature and better long term results due to UV resistance.

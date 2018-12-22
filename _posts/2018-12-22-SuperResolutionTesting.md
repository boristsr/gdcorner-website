---
layout: post
title:  "Testing Texture \"Super Resolution\" Techniques"
date:   2018-12-22 17:28:13 +1100
categories: rainbowsix gamedev superresolution rendering
---

After seeing [Doom Neural Upscale 2X by hidfan](https://www.doomworld.com/forum/topic/99021-v-0-95-doom-neural-upscale-2x/), I became interested in testing out "super resolution" techniques on the images found in Rainbow Six and Rogue Spear.

[Super Resolution](https://en.wikipedia.org/wiki/Super-resolution_imaging) is the process of taking a smaller image and generating extra detail to output a larger resolution image without just blurring the smaller image. Although there are many varied techniques, I will be focussing on [neural network](https://en.wikipedia.org/wiki/Artificial_neural_network) based techniques in this article. The Neural networks have been trained on a large dataset of small images that are then compared against larger version, and the difference is then used to train the model. The result is a network that can restore missing detail in an image and the results can appear to be magic.

<!--more-->

## Goals / Requirements

To properly evaluate I needed some criteria that results could be compared against. Primarily these are that the results look good, and I don't want to manually tweak thousands of images. My ideal list is:

1. High resolution textures from existing data
2. Low noise, low artifact results
3. The process can be fully automated with no human intervention on a per image basis.
4. Pre-processing and post-processing of images is ok, as long as the process can be automated and applied to all images.
5. Services with no possibility of API access are a no-go.

## Initial testing

I ran into [ESRGAN (Enhanced SRGAN)](https://github.com/xinntao/ESRGAN) after reading a [DSOGaming article](https://www.dsogaming.com/news/morrowind-enhanced-textures-is-a-must-have-mod-that-upscales-texture-by-4x-with-esrgan-technique/) on the [Morrowind Enhanced Textures mod](https://www.nexusmods.com/morrowind/mods/46221?tab=files). The results looked promising, and since it was open source I could run it locally and not worry about API quotas or high costs. It was a natural first choice.

First I ran all the textures from the first mission of Rainbow Six through ESRGAN using the model RRDB_ESRGAN_x4. The results were mixed. Undoubtedly the textures were higher resolution and sharper, but overall there was too much harsh detail added and it had a very strong appearance of being over-sharpened.

I ran the same textures through again, but using the model RRDB_PSNR_x4. These textures appeared over-smoothed, and didn't add the detail that the previous model had achieved. While there were some improvements in texture detail, there was still a lot of artifacts introduced. Overall the best case of these results were not substantially better than bilinear scaling in realtime, and the worst case was significant visual artifacting, the benefits do not outweigh the issues.

More details on the differences between the 2 trained models are available in the paper [ESRGAN: Enhanced Super-Resolution Generative Adversarial Networks](https://arxiv.org/abs/1809.00219). The paper also discusses mixing the results of the 2 models to reduce artifacting, which I explore a little later.

These screenshots are taken with Blender loading one set of textures at a time. Click to see the full image, zoom for more detail.

Original Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/int1_Original.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/int1_Original.jpg)

RRDB_ESRGAN_x4 Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/int1_RRDB_ESRGAN_x4.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/int1_RRDB_ESRGAN_x4.jpg)

RRDB_PSNR_x4 Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/int1_RRDB_PSNR_x4.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/int1_RRDB_PSNR_x4.jpg)


As you can see in these screenshots using RRDB_ESRGAN_x4 the wall textures appear quite harsh, however the books have come up about as well as could be expected using RRDB_ESRGAN_x4. The improvements seen with RRDB_PSNR_x4 are better but not earth-shattering.

Original Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext1_Original.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext1_Original.jpg)

RRDB_ESRGAN_x4 Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext1_RRDB_ESRGAN_x4.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext1_RRDB_ESRGAN_x4.jpg)

RRDB_PSNR_x4 Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext1_RRDB_PSNR_x4.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext1_RRDB_PSNR_x4.jpg)

From these shots, take note of the bricks on the fence, the bricks on the embassy, and the tiles on the driveway. Certainly a these bricks have come up extremely well, however the tiles have an over-exaggerated streak-like pattern. With the PSNR model the streaking remains, and the textures gain a little sharpness, but not enough to justify the artifacts. The textures that were generated by the RRDB_ESRGAN_x4 model also appear quite a bit brighter.

Original Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext2_Original.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext2_Original.jpg)

RRDB_ESRGAN_x4 Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext2_RRDB_ESRGAN_x4.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext2_RRDB_ESRGAN_x4.jpg)

RRDB_PSNR_x4 Textures
[![Original Textures]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext2_RRDB_PSNR_x4.jpg)]({{ site.url }}/assets/posts/2018-12-22-SuperResolutionTesting.md/ext2_RRDB_PSNR_x4.jpg)

In these comparisons look at the buildings in the background, the hedges, flowerbed, and the concrete and grass around the pond. The buildings are affected by significant artifacting. The concrete and grass around the pond gains minor sharpness improvement, but it is noticeable and acceptable in both models. The hedgerow sees another decent boost in sharpness. The flowerbed once again exhibits an over-sharpened appearance with both models.

## Hybrid approach

Taking a page out of hidfans' book, I tried averaging results from a few sources. I used M13_Loading.png which is a 640x480 image displayed when loading the mission (who would have guessed?). I ran this through:

- [letsenhance.io](letsenhance.io)
- ESRGAN with pretrained model: RRDB_ESRGAN_x4
- ESRGAN with pretrained model: RRDB_PSNR_x4

Once I had all three results, I opened these in photoshop and stacked them to get the mean color. This did help to smooth out some of artifacts, but it was far from perfect. I tried downsampling the images, which did help with noise, but there was still a lot of artifacting. Strange lines and striations, halos, etc.

## Color Dithering issues

At this point I realised a lot of the noise or strange artifacts were around areas where a [dithering pattern](https://en.wikipedia.org/wiki/Dither) was visible. This is because the source textures are extracted from the game where all textures and images are stored as 16bit images, this means that the color channels Red, Green and Blue store colors in 5, 6 and 5 bit precision respectively. In some cases, an alpha channel is also stored giving just 4 bits per channel. To prevent this loss of precision causing extreme [color-banding](https://en.wikipedia.org/wiki/Colour_banding) and give the appearance of higher color precision the textures have been encoded with a dithering pattern during the conversion which helps hide this to the human eye. Unfortunately the neural networks are reading these patterns as detail.

To attempt to alleviate this I tried manually applying a denoising filter in Photoshop to the source image. I tried to remove as much of the dithering as possible while retaining detail and without over-sharpening or over-smoothing.

I then followed the same process.

1. Run through all upscalers/models
2. Average in photoshop
3. Downsample using "Bicubic (smooth gradients)"

The results were improved, especially around areas with a lot of dithering, however there were a large number of artifacts remaining. A slightly stronger de-noise filter would smooth out the remainder of the issues around dithering. It's probable other artifacts will be lessened with more pre-processing.

## Conclusion

The results achieved by hidfan on [Doom Neural Upscale 2X](https://www.doomworld.com/forum/topic/99021-v-0-95-doom-neural-upscale-2x/) are amazing. I'd really like to achieve a similar level of success in upscaling textures for Rainbow Six and Rogue Spear however the current approaches I've tried are extremely promising but they aren't quite meeting my needs. In comparison to the [Morrowind Enhanced Textures mod](https://www.nexusmods.com/morrowind/mods/46221?tab=files), these source textures are extremely low resolution and cover large portions of the screen. This means small imperfections are significantly more noticeable, which I suspect it is the reason I'm not getting results that are as acceptable.

Only being able to achieve a 4x upscale didn't allow much wiggle room to hide artifacts with downsampling and averaging. Ideally finding an approach that allows an 8x upscale would benefit a lot. However the larger you upscale, the more data has to be inferred, which leads to more chance for artifacts. I'm confident that using different neural networks that perhaps have been trained on larger data sets will yield better results.

Issues surrounding dithering induced noise caused significant amounts of artifacts which would require a lot of hand tweaking. A quick test with denoising provided very promising results. A more robust pre-processing stage will alleviate this problem and possibly others, but will require fine tweaking to ensure maximum detail is still preserved.

The upscaling processes themselves introduced significant artifacts, so a post-processing stage will definitely be needed. Using multiple services or networks and averaging the results definitely improved the results. I suspect averaging too many results will result in a blurry image and best results will probably be obtained by selecting the best 2-3 results. Halos and bright spots were common artifacts. I'd like to explore using the source image in a post-processing stage to remove hot pixels.

It's still early days in my project so I have plenty of time to let these things mature, and more importantly, experiment more!

## Further work

In the future I'd like to evaluate more software, other neural networks, and other techniques. Of most interest are services and software that can achieve higher than 4x upscaling, allowing more wiggle room to downsample and hide artifacts. I've applied for access to [NVIDIA Gameworks: Materials & Textures](https://developer.nvidia.com/gwmt), and when I get a chance I'll try out [Topaz AI Gigapixel](https://topazlabs.com/ai-gigapixel/). There are also numerous research papers available which have shared their trained model and code on github, and I will keep an eye out for promising ones.

After reading through the early thread on Doom Neural Upscale it appears that translucency was a problem for these techniques. I'll need to pay special attention to these, or copy translucency and masking values from the source files and upscale the alpha channel or color masks the old fashioned way.
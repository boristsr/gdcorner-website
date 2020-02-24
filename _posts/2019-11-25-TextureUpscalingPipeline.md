---
layout: post
title:  "Texture Upscaling Pipeline"
date:   2019-11-25 11:17:13 +1100
tags: [Development, python, SuperResolution, ImageProcessing, RainbowRedux]
comments: true
---

At the beginning of the year I wrote about my [initial experiments with image super resolution]({{ site.url }}{% post_url 2019-01-04-SuperResolutionTesting %}). This week I focused on some of the improvements I discussed and implemented a pipeline.

I’ve written an image processing framework which I'm [releasing](https://github.com/boristsr/TextureUpscalingPipeline) under the [MIT license](https://github.com/boristsr/TextureUpscalingPipeline/blob/master/LICENSE). The goal is to allow rapid iteration of image processing until good results are achieved in the majority of cases reducing or eliminating the need for any manual editing of images.

![Denoised before ESRGAN and then downsampled]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Desk-Downsampled-Denoised.jpg){: .enable-lightbox}

<!--more-->

The pipeline can be easily modified to add, remove and tweak processing passes which makes it incredibly quick to iterate on how the images get processed. The ability to move passes around in particular has been nice to experiment with. An example is testing whether performing alpha channel recovery before or after downsampling produces better results.

## Current Status

To get this working nicely I’ve [forked ESRGAN](https://github.com/boristsr/ESRGAN) so I could add a few improvements. I’ve added CUDA detection so it can automatically fallback to CPU processing, as well as an improved command line interface, allowing execution of ESRGAN with an optional model specified.

The pipeline itself currently has the following features

* Denoising with OpenCV
    * Helps remove features that encourage artifacts in ESRGAN. In particular dithering noise is a problem.
* Alpha channel recovery
    * Since ESRGAN, and presumably other upscalers, drop the alpha channel it is required to add it back. This process resizes the original image with bicubic resampling and then copies the alpha channel into the upscaled image.
* Downsampling
    * Halve the output size to reduce artifacts output by ESRGAN
* Saving images beside the originals
    * **example.png** becomes **example.HIRES.png**

## Future Work

Now that this pipeline is in place I plan to iterate much more quickly over this process. Some of the improvements I’m planning are:

* Additional super-resolution implementations
    * NVIDIA (If I can get access)
    * Gigapixel
    * Topaz
* Improved denoising algorithm
* Ability to save the processing state so an individual pass, or set of passes, can be iterated quickly without the need to perform all the preceding passes
* Edge highlight removal
    * Many of the upscaled textures are getting halo-like effects as edges and some lines are over-emphasized. Automatic processing on these to darken or de-emphasize this would be nice.

## Results

Here are some examples of the results from this pipeline. The passes are exaggerated here to show off denoising. This pipeline allows these passes to be tweaked rapidly until a nice result is achieved in the majority of circumstances.

### Desk & Office

This scene shows off a lot of detailed textures which demonstrate the results of the different passes.

Original
![Original]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Desk-Original.jpg){: .enable-lightbox}
Unfiltered ESRGAN
![Unfiltered ESRGAN]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Desk-UnfilteredESRGAN.jpg){: .enable-lightbox}
Denoised before ESRGAN
![Denoised before ESRGAN]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Desk-Denoised.jpg){: .enable-lightbox}
ESRGAN Downsampled
![ESRGAN Downsampled]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Desk-Downsampled.jpg){: .enable-lightbox}
Denoised before ESRGAN and then downsampled
![Denoised before ESRGAN and then downsampled]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Desk-Downsampled-Denoised.jpg){: .enable-lightbox}

### Translucency

[Rainbow Six](https://en.wikipedia.org/wiki/Tom_Clancy%27s_Rainbow_Six_(video_game)) doesn't have too many translucent textures, mainly masked alpha textures, but here is an example of some glass to see the alpha channel recovery. You can also see the metal beams which are a masked transparent material.

Original
![Original]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Tunnel-Original.jpg){: .enable-lightbox}
Denoised before ESRGAN and then downsampled
![Denoised before ESRGAN and then downsampled]({{ site.url }}/assets/posts/2019-11-25-TextureUpscalingPipeline.md/Tunnel-Downsampled-Denoised.jpg){: .enable-lightbox}

### Where to download

This is all available on my github here: [Texture Upscaling Pipeline](https://github.com/boristsr/TextureUpscalingPipeline)
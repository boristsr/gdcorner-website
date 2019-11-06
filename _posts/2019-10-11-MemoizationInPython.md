---
layout: post
title:  "Cheap Optimization with Memoization in Python"
date:   2019-10-11 11:17:13 +1100
tags: [python development optimization]
comments: true
---

[Memoization](https://en.wikipedia.org/wiki/Memoization) is a technique to cache the result of a function or program for a given input. It's an incredibly simple optimization to make, and in the right circumstance significant speedups can be achieved.

<!--more-->

## Introducing Functools

[Functools](https://docs.python.org/3/library/functools.html#module-functools) is a module that is included in the python standard library, providing a whole range of functions and decorators. I was browsing a few developer forums (I can't remember which one) and I stumbled across people mentioning [functools.lru_cache](https://docs.python.org/3/library/functools.html#functools.lru_cache). I had a quick look into it and it seemed very simple to use. I wrote a program a few months ago where I had written a quick result caching feature, it was a perfect place to try this.

## Experimenting with lru_cache

The program that I tested on read all images from a game that were in an old game specific format and converted to full color PNG files. The complexity is that the colors are all packed into 16 bits so there is a lot of bit shifting, masking and so on that is required to convert back to full 32 bit color images.

```
ncalls      tottime  percall  cumtime  percall filename:lineno(function)
37876344    7.270    0.000   14.887    0.000 BinaryConversionUtilities.py:207(bytes_to_shortint)
37876344   86.094    0.000   86.094    0.000 BinaryConversionUtilities.py:218(calc_bitmasks_ARGB_color)
37876344  108.527    0.000  214.896    0.000 BinaryConversionUtilities.py:247(read_bitmask_ARGB_color)
43022383   19.481    0.000   21.861    0.000 BinaryConversionUtilities.py:25(read_bytes)
```

Profiling previously revealed there were 2 functions that were run for every pixel. They didn't take particularly long each iteration, but cumulatively they were where the majority of program run time was spent so any improvement would be beneficial. The first function I had already tried a really rough hashing method for the inputs quickly before moving on. The above profiling results were taken before any caching or memoization had taken place. The process of removing my quick prototype and replacing with lru_cache was painless, the changes can be seen below.

Existing Function:
```python
previousMasks = {}
def calc_bitmasks_ARGB_color(bdR, bdG, bdB, bdA):
    """Calculates the appropriate bitmasks for a color stored in ARGB format."""
    key = str(bdA) + str(bdR) + str(bdG) + str(bdB)	
    if key in previousMasks:	
        return previousMasks[key]

    ...

    masks = [redMask, greenMask, blueMask, alphaMask]
    previousMasks[key] = masks	
    return masks
```

Modification to use lru_cache:
```python
import functools

@functools.lru_cache(maxsize=8)
def calc_bitmasks_ARGB_color(bdR, bdG, bdB, bdA):
    """Calculates the appropriate bitmasks for a color stored in ARGB format."""

    ...

    masks = [redMask, greenMask, blueMask, alphaMask]
    return masks
```

Results:
* No caching: 4m36s
* Prototype caching: 3m48s
* lru_cache: 3m22s

As you can see the benefit was noticable, and it simplified my code [which is always positive](https://blog.codinghorror.com/the-best-code-is-no-code-at-all/). I'm sure atleast part of the speedup came from a better hashing function which avoided converting all inputs into strings.

The really impressive part though was how easy it was to implement. This made it too easy to not test the second function. However, some changes were required. This works best with primitive types ([technically it only requires all arguments to be hashable](https://docs.python.org/3/library/functools.html#functools.lru_cache)), so arguments that are objects or arrays make this ineffective.

This function took 2 bytes as an argument and converted them into a shortint, it was easy enough to make the changes so that the conversion was made before calling this function. In fact this change made for a better and more usable function anyway.

Before:

```python
def read_bitmask_ARGB_color(byteStream, bdR, bdG, bdB, bdA):	
    """
    Reads an ARGB color with custom bit depths for each channel,
    returns in RGBA format
    """
    colorVal = bytes_to_shortint(byteStream)[0]	
    masks = calc_bitmasks_ARGB_color(bdR, bdG, bdB, bdA)
    
    ...
```

After:
```python
@functools.lru_cache(maxsize=None)
def read_bitmask_ARGB_color(colorVal, bdR, bdG, bdB, bdA):
    """
    Reads an ARGB color with custom bit depths for each channel,
    returns in RGBA format
    """
    masks = calc_bitmasks_ARGB_color(bdR, bdG, bdB, bdA)

    ...
```

Results:
* No caching: 3m22s
* lru_cache: 1m35s

These results are awesome. It makes sense since the images tend to have areas that contain the same color in close proximity.

I should note that the reason these results are so impressive is because these functions are called for every pixel in every image, leading to a huge number of calls. If I restructured the functions I could get some of these improvements without caching, however since these are used in a number of other contexts caching is my preferred option.

These results are now in the same ballpark as using [PyPy](https://pypy.org/) which [JIT compiles](https://en.wikipedia.org/wiki/Just-in-time_compilation) the program producing near-native speed. Being able to achieve this in the standard Python implementation is fantastic.

Results:
* CPython no caching: 4m36s
* CPython lru_cache: 1m35s
* PyPy no caching: 2m6s
* PyPy lru_cache: 1m15s


## When to use

This is a an example of a [time-memory tradeoff](https://en.wikipedia.org/wiki/Space%E2%80%93time_tradeoff), less time is required at the expense of more memory being consumed. With that in mind this is most effective when the same set of inputs will be regularly used. Profiling as well as having an understanding of your data and program will help you get an idea of what functions will benefit, and how big the cache size should be.

When choosing a cache size understanding the data will help but try a few values to see what works best. Too large your program may end up using too much memory. Too small and there won't be an effective speedup. In memory limited environments or on large datasets batching or grouping similar requests may help to avoid churning the cached results and reduce memory usage.

The [python documentation](https://docs.python.org/3/library/functools.html#functools.lru_cache) also has a few pointers on choosing whether using it is appropriate or not.

Knowing this is in the standard library makes it really easy to try using this technique. If you can spare the memory and think a function may benefit from being cached then I highly recommend giving it a try.
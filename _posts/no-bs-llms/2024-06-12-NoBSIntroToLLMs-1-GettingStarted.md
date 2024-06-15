---
layout: post
title:  "#1 - Getting Started - No BS Intro To Developing with LLMs"
date:   2024-06-12 13:29:13 +1100
tags: [ubuntu, llms, rag, no-bs, python, llama.cpp]
comments: true
image: "/assets/posts/no-bs-llms/no-bs-llms-ogimage.png"
description: "A No BS guide to getting started developing with LLMs. We'll cover the jargon, terms, and get a model running locally. We'll also cover the different model formats, and how to convert and quantize a model."
categories: blog
menubar_toc: true
series: no_bs_llms
---

While experimenting with LLMs over the weekends I grew very frustrated trying to decipher terms, and find good information on all the new advances. It was difficult to find a good A to Z beginner guide. Finding information like precise definitions was tough because particular morsels of information were hidden on Reddit, different repos, issue trackers and so on. Some definitions were never clear because it was just assumed knowledge. To make matters worse was the state of search engines these days and SEO constantly showing blog posts that were just ads and sales funnels for hosted services, thin GPT wrappers, or paid medium articles.

While getting myself up to speed I took extensive notes that answer the questions I had, and decided to turn them into a series of articles in the hopes that it helps anyone else with similar frustrations. This is the guide I wish I had!

I’m going to walk you through building a basic voice assistant. Along the way I’ll introduce the terminology, build up a glossary of terms, introduce concepts, and show clear concise examples at each step. **I’m not going to sell you anything**, we’re going to use free and open source projects and use some of the emerging standard pieces of tech with no BS.

While I don’t find chatbots particularly exciting or the “killer app” of LLMs, it provides an excellent self-contained project where we can explore the tech, and introduce all the concepts and terminology in a straight forward way. After this series you’ll be well prepared to unlock the worlds of potential LLMs have for content moderation, sentiment analysis, data cleanup, summarization and other Natural Language Processing (NLP) heavy tasks that were previously incredibly difficult or impossible.

I’ll lay out some of the different tech choices that can be made and explain the reasoning behind choosing a particular one for this introduction. We’re going to self host everything for the purposes of this series. Working locally will mean there is no fear of unexpected costs and data leaks. I personally find these fears are devastating for my own experimentation. I believe working locally reduces many of the barriers to early experimentation.

Let’s get started!

## What we’ll cover

We begin with 3 articles in this series, but I have a few more planned to keep diving deeper into the tech and concepts. 

In this first article we’ll cover a lot of the initial jargon and terms you’ll find. We’ll then download a model, and get a basic chat loop going in code.

In article 2 we’ll look at using an LLM via network APIs so we can connect to other LLM services, as well as explore a lot more about working with LLMs, generation settings, chat templates and so on.

Article 3 will guide us through adding some basic voice interactivity since processing speech from live microphones or recordings will be very useful to many LLM applications.

If you’re an absolute beginner and are absolutely bamboozled with all the jargon and terms, stick with article 1 which will get you up to speed in no time.

## LLMs and Transformers

This article assumes you know what LLMs are, at least from a users perspective, and will dive into the practical details of using them, exploring terms as they come up only to the depth required to choose models and develop applications that use LLMs. We specifically won’t be going into the internals of LLMs and Transformer architectures. Having said that, there are terms we’ll briefly cover as you’ll see them come up a lot, but don’t worry, they sound a lot more complicated than they are.

- **Tokens** - This is the pieces of words, sentences and grammar that LLMs work with. They don’t directly map to any human concept, but you can almost imagine these like syllables and punctuation. They can represent anything from a single character to a whole word, but generally they represent a few letters or characters and words often break up into multiple tokens. Each model family defines it’s own token set, and some models that are trained off a base model define additional tokens. A larger token vocabulary generally means that fewer tokens are needed to represent a given set of text.
- **Embeddings** - Embeddings are large 2D matrices where each token is represented by a large vector (1D matrix) that captures its meaning and concepts. This is the final representation of a sequence that the LLM works with. We don’t need to touch on this for a while and will likely only become relevant for us when we get to data storage and lookup, known as Retrieval Augmented Generation (or RAG). I’ve linked some resources in the next section if you’d like to know more.
- **Autoregressive** - This means that the model predicts the next token, adds it to the input, and then the process begins and again and starts predicting the next token.
- **Causal LM / Causal Language Model** - This simply means that the language model predicts the next token or word forward based on previous tokens only. It can’t look ahead at future tokens, it will only continue the sequence of what was provided so far. This is the most common model type you’ll use currently.
- **Context Length** - This is how much text, or history that can be considered at a time by the LLM. It’s expressed in number of tokens. A larger context window means more tokens, and therefore more text can be processed at a time.
- **Transformers** - These are the core of LLMs. It’s a [deep learning architecture developed by Google in 2017](https://en.wikipedia.org/wiki/Transformer_(deep_learning_architecture)), and has been one of the key technological advances in the development of LLMs.

## Resources for Learning ML and Transformers Internals

If you want a deeper dive into the internals of LLMs and Transformers I’d recommend the [3Blue1Brown video series on Neural Networks](https://www.youtube.com/playlist?list=PLZHQObOWTQDNU6R1_67000Dx_ZCJB-3pi), specifically videos 5 and 6 focusing on embeddings and transformers which helps build a solid understanding of all the concepts involved. After that consider doing the [Hugging Face Natural Language Processing course](https://huggingface.co/learn/nlp-course/chapter1/1). 

If you want to take a closer look specifically at embeddings, I found this article was really informative - [A Beginner’s Guide to Tokens, Vectors and Embeddings in NLP by Sascha Metzger](https://medium.com/@saschametzger/what-are-tokens-vectors-and-embeddings-how-do-you-create-them-e2a3e698e037).

Another suggestion I wanted to throw out there if you want to dive deeper is getting familiar with linear algebra. I come from a Game Development background and a lot of the math for handling geometry and transformations such as rotation, translation, projecting to screen space and so on are all done with vectors and matrices. You learn to visualise these operations and build up a pretty good intuition on working with them in 3 dimensions. I’ve found that a lot of the ML theory has been a very natural progression for me with this background, while you can’t visualise multi-thousand dimension vectors, the math follows pretty simply. If you want to get familiar with some of that math in a fairly intuitive way, my personal favourite book on the matter is freely available, [3D Math Primer for Graphics and Game Development](https://gamemath.com/). The first few chapters are of particular interest.

## Setting up our project

This guide assumes you are working in Ubuntu 24.04. You should be able to follow along just fine in Windows with WSL, and with a few minor modifications on Mac OS too. Make sure you have around 10gb or more of RAM and around 50-60gb of disk space free. We're going to have a few copies of the model on disk during the conversion process so we need some extra space.

The main things we want are:

- **Git** - The version control tool
- **Git-LFS** - Large File Storage extensions for git. This allows us to work with files that are many gigabytes within the familiar git workflow.
- **Build-Essential** - This is a metapackage in Ubuntu that has a bunch of C and C++ tools which will be required to compile some tools later.

```bash
# Install some build tools
sudo apt-get install -y git git-lfs build-essential
```

One complication is that llama.cpp [doesn’t support Python 3.12 yet](https://github.com/ggerganov/llama.cpp/issues/6422) due to some dependencies. So along with some tools we’ll also need to install Python 3.11 which isn’t available in the official Ubuntu 24.04 repositories. [Deadsnakes is a very popular repository](https://launchpad.net/~deadsnakes/+archive/ubuntu/ppa) to get alternative builds of Python. This is the method we’ll use until Python 3.12 is fully supported.

```bash
# Install Python 3.11
sudo apt install -y software-properties-common
sudo add-apt-repository ppa:deadsnakes/ppa
sudo apt update
sudo apt install -y python3.11 python3.11-venv
```

Finally we’ll setup our project folder

```bash
# We'll work in a directory for this project
mkdir chatbot
cd chatbot

# We'll be working with python a fair bit, so we'll setup a virtual environment to work in
python3.11 -m venv .venv
# Activate the virtual environment
source .venv/bin/activate
```

## Speed vs Performance

A quick note during this series I’ll refer to speed and performance of the model regularly. I’ll try and maintain the convention that

- **Speed** is the inference, or generation speed of the model
- **Performance** is the quality of the generated results.

## Where to Begin

First up, we’re just going to run a model locally and that introduces the first 2 questions: How? And what model?

## Model Runtimes / Engines

There are so many ways to run models now. But what’s best? Which should you choose? There’s no right or wrong answer. Here are a few of the more popular solutions available and why we’ll settle on a particular method for this series.

Just quickly before diving in, lets just take a moment to go over some terms that will repeatedly come up:

- **Jupyter notebooks** are a bit like a special case of python scripts that allow intermingling of code and notes, as well as a semi-interactive python interpreter allowing you to adjust and rerun pieces of code in-line. They are excellent tools for learning, note taking, interactive experimentation and data science.
- **PyTorch** is a python library dedicated to machine learning / ML. It has a whole host of tools within it. Of particular interest is it’s fast implementations of neural networks and tensors, and algorithms for training them. I’m not diving into the particulars of PyTorch in this series, but the name will pop up regularly, so it’s worthwhile understanding what it is.
- **HuggingFace Transformers** is another python library specifically for working with transformer networks, and downloading existing models hosted on HuggingFace. It builds on top of PyTorch, TensorFlow and JAX which are more generic ML libraries.

### Reference Implementation / PyTorch

Each model generally comes with it’s own reference implementation which is a python script or scripts, or a Jupyter notebook, and runs using PyTorch or the HuggingFace Transformers Library, or similar Machine Learning framework. This is how the model was developed and gives a good baseline for the performance of a model. For our purposes, this isn’t particularly interesting, but if you want to dive deep on a particular model, or family of models, you might want to look into this.

### Ollama

[Ollama](https://ollama.com/) is a popular and quick way to run models. It’s easy to install on Mac, Windows and Linux. With a single command you can download and run a model. [There’s a nice web interface to browse the available models](https://ollama.com/library). The models are pre-quantized so they can run on much lower end hardware than the original source model.

There is a large ecosystem of integrations and tools that work with Ollama, so it’s an excellent way to prototype and quickly interact with models, and even target when developing applications since it’s server mode is quite popular. We want to dive a fraction deeper so we can hit some of the interesting details ourselves. Under the hood this uses Llama.cpp.

This is available under the MIT license which is very permissive.

### Text Generation WebUI

[Text Generation WebUI](https://github.com/oobabooga/text-generation-webui), sometimes called Ooga Booga after the developers GitHub account, is another popular option. This is more of an application itself. It does have an OpenAI compatible API, but it’s probably not something I’d build on top of, instead this is what I use for a bit of a playground and quick chat interface with existing models. This automatically installs Llama.cpp, but also contains other methods of running and connecting to LLMs.

This is under the AGPL 3.0 license which has some considerations when using it commercially.

### Llamafile

[Llamafile](https://github.com/Mozilla-Ocho/llamafile) is a very interesting project from Mozilla that embeds a cross platform runtime in with the model itself. This allows you to download a single file, double click it, and start interacting with the model immediately. The runtime is a fork of Llama.cpp. The developers of Llamafile have been very active in adding speed improvements as well as submitting these upstream to Llama.cpp

This is under the Apache License 2.0 which is quite permissive.

### Llama.cpp

[Llama.cpp](https://github.com/ggerganov/llama.cpp/) is a very fast implementation of inference for LLMs. It started off as a CPU implementation for Llama2 but has expanded to support a wide range of models, with a large set of backends including GPU support via CUDA, Metal and Vulkan. It can also run the models in a hybrid state where part of the model runs on CPU and part runs on the GPU. It even runs on Raspberry Pis and Androids! As you can imagine, this is a very powerful and useful piece of tech. Basically, you can run this anywhere on whatever you have.

This is available under the MIT license which is very permissive.

### Llama-cpp-python

[Llama-cpp-python](https://llama-cpp-python.readthedocs.io/en/latest/) is a python wrapper around llama.cpp. This is the first thing we’ll use before moving directly to Llama.cpp.

### Others

There are SO MANY ways to run LLMs these days, these are just a few of the popular ones you’ve likely heard about. There’s more including Koboldcpp, NVIDIA ChatRTX, LM Studio, as well as full frameworks for end-to-end processing and agents like LangChain, LlamaIndex, Crew.ai, Autogen, the list goes on.

### Final Choice

Once again, our goal here is working with LLMs in a more bare-bones practical sense so we can learn some of the behind-the-scenes details these existing frameworks and tools abstract away. You can see that llama.cpp plays a central role in most of these options. You can also run llama.cpp just about anywhere on whatever hardware. As a result, we’re going to cut out most of the intervening layers and just work directly with llama.cpp and llama-cpp-python so we can get a little closer to the nuts and bolts, while allowing us to experiment on whatever hardware we have laying about. In the second article we’ll also move towards a way of running the models that should allow you to change how you are running the model quite transparently to the application you are building.

## Choosing A Model

Quantized, 7b, 13b, Q5_? WTF? 

Ok, there’s lots of Jargon you’ll run into when choosing a model, let’s break down some of them. 

**Parameters** - This is the number of weights in a model. Usually expressed in billions or trillions, hence the 7B, 13B, 1.7T. The number of parameters directly affects the memory required to run the model, as well as the processing power required to generate text quickly. This can be used to also quickly estimate the minimum amount of RAM required to run the models at the original quality and how big the download will be. Without going in-depth on model configuration and architecture, a lot of models use 16bit floating point numbers for the bulk of their weights, so `7,000,000,000 parameters * 2 bytes = 14,000,000,000 bytes = 14 gigabytes of memory`

**Quantized / Quantization / Q4 / Q8**  - This is a form of lossy compression. Essentially it tries to balance keeping as much original data and performance as possible while discarding information that doesn’t impact the results from the LLM by a significant amount. I’ll be covering this in a bit more depth after we’ve downloaded a model. We’re going to download a model at it’s full precision first, and learn how to quantize ourselves.

**Base / Chat / Instruct Models** - These are different levels, stages, or purposes of training. A base model has had the vast majority of training performed. This is the expensive part of training and building a model. The Chat and Instruct variants have had a further level of training, also called fine-tuning, performed on them to target them for a specific purpose or use. **Instruct** is also known as “instruction following”. This is useful for models that you might be asking to summarize documents, or perform specific tasks. **Chat** variants are more targeted at chat-bots and assistants and are good at the question/answer prompt formats.

**Fine-Tuning / Fine-Tuned models** - Fine tuning is a form of training performed on pre-trained models. A Base model can be fine tuned into a Chat or Instruct model for instance. Fine tuning can change the style of a models output, or help it perform better on specific tasks or formatting. There is some debate around how effective fine-tuning is for adding new knowledge to an LLM.

**LoRA / QLoRA / PEFT** - These are techniques used in fine-tuning to drastically reduce memory and computation requirements. They have no bearing on a model after it has been trained. **Very occasionally** you may run into a model which is only available as a “LoRA”, what this means is it’s the result of fine-tuning, but the results haven’t been “applied” or merged in to the model. You can think of it kind of a like a `diff` or a set of delta changes. In this instance you would be required to load the original model and then apply the LoRA, or you can simply merge the LoRA into the original model and save as a new file which you can load as you would any other model.

**Mixture-Of-Experts / MoE** - This is a model architecture where only parts of the model are used/activated at a given time. You still need to be able to load the full model into memory for fast inference/generation speeds, because the model will decide which expert is needed for the next bit of the sentence being generated. Since only a portion is being used at any given time this dramatically speeds up the inference / generation speed of the model. Mixtral for instance only uses 2 experts at a time, and is made up of eight 7 billion parameter expert models, so your generation speeds are closer to a 15b parameter model. However just to be clear, these experts aren’t selectable. You can’t just say “Well, I don’t need medical information, so I’ll turn off that expert”. That’s not how it works, and I’m not sure it’s entirely clear which portion of the model contains which bit of knowledge or training. This is purely a computation optimization, not knowledge segmentation.

**Merge / Merged Model** - This is a process where 2 models can have their weights merged and the result can outperform both original models. It’s an interesting concept that can produce interesting results.

## Model Formats

Models can be packaged, distributed and run in several ways. The runtime method chosen often dictates what model format you need. Thankfully there’s only a few we need to worry about, but here’s some terms you’ll run into a fair amount.

[PyTorch](https://pytorch.org/) - This isn’t an LLM format exactly, rather just a generic PyTorch model, and it can be saved in several ways.

.pt / .pth / .bin - This is a generic serialization format for PyTorch models. This is serialized using [Pythons Pickle](https://docs.python.org/3/library/pickle.html) library which can also contain and execute python code during the unpacking process which naturally has some security concerns, especially if you start getting real experimental and downloading many arbitrary models to test with.

[SafeTensors](https://huggingface.co/docs/safetensors/index) - This is a new method of serializing a model. While a PyTorch model saved via the pickle method can contain arbitrary code, SafeTensors cannot, so it’s a more secure format for sharing models.

[HuggingFace / hf / Transformers](https://huggingface.co/docs/transformers/index) - This is generally just a PyTorch or SafeTensors model with a specific layout of files to define the model, the model architecture, the tokenizer etc. This is compatible with the HuggingFace transformers library. This is the kind of model we’ll download.

GGUF (GPT-Generated Unified Format) - This format is developed alongside the Llama.cpp project, and is therefore the one we’ll be using for inference / generation. All necessary data is packed into a single file.

GGML - This is the predecessor to GGUF and is obsolete now. You should convert to or stick with GGUF.

[JAX](https://jax.readthedocs.io/en/latest/) - JAX is a high performance machine learning library from Google, who release some of their models with a variant that supports JAX.

[ONNX Runtime](https://onnxruntime.ai/) - ONNX is an AI framework from Microsoft. Microsoft typically release their models with an ONNX variant.

The vast majority of models have a HuggingFace Transformers variant released, so this is a good format for us to focus on since it’s quite widely supported / available.

Generally a HuggingFace model will be comprised of many files, here’s some of the files you can expect to see in a HuggingFace model.

- `config.json` will describe some model configuration
- `generation_config.json` defines some runtime parameters like context length and temperature
- `*.safetensors` or `*.bin` stores the actual model weights and the different matrices. There might be multiple of these files, especially for very large models.
- `*index.json` defines which part of the model is stored in which file. May not exist if the model you downloaded isn’t split into files.
- `tokenizer.json`, `special_tokens_map.json` - These define the tokens for the model. You can open this in a text editor and see all the token IDs and their associated string.
- `tokenizer_config.json` - Configuration of the tokenizer.

The models I will recommend and link are all in the HuggingFace format, and we’ll convert to GGUF after we’ve downloaded a model. Thankfully Llama.cpp includes tools and scripts to convert the model we download from a HuggingFace format model to a GGUF model.

## Downloading a Model

Ok, so now some of the terminology is out of the way, it’s time to pick a model. I’ve linked some of my go-to models below. These are generally very good models to start with. There are a bunch of competing fine-tunes and merged models that stem from these models. The fine tunes are constantly topping the leader-boards, but my preference is to stick with these models for the most part. That’s the beauty though, download whatever models look interesting to you and give them a shot!

A quick note: [Some research has shown that it’s possible to embed sleeper trigger prompts into a model with fine tuning](https://arxiv.org/abs/2401.05566). Personally I stick with models from the larger organizations or the more popular models you can find recommended on the LocalLlama subreddit. This is no guarantee of safety from these risks, but if you are building something professional or trying to make a safer application it’s probably best to consider this potential attack vector when selecting a model.

If you want other recommendations on models make sure to checkout the [LocalLlama subreddit](https://www.reddit.com/r/LocalLLaMA), and the [HuggingFace Open LLM leaderboard](https://huggingface.co/spaces/HuggingFaceH4/open_llm_leaderboard) and the [LMSys ChatArena Leaderboard](https://chat.lmsys.org).

Most models can just be cloned with Git LFS, or you can individually download all the important files. For this example I’m going to use [Llama-3-8b-Instruct](https://huggingface.co/meta-llama/Meta-Llama-3-8B-Instruct). You will need to create a HuggingFace account and accepted the license agreement to get access to this model.

```bash
# You will be asked for your huggingface username and password to clone this.
git clone https://huggingface.co/meta-llama/Meta-Llama-3-8B-Instruct
```

Another option to get models is to use the [HuggingFace Hub CLI tools](https://huggingface.co/docs/huggingface_hub/main/en/guides/cli.). I won’t be covering this though I wanted to draw your attention to it as an alternative. It can be worthwhile as it can require less space on your disk when you download it.

### My Recommended Starting Models

This field moves fast, models are released regularly, but at the time of writing (June 12th, 2024) these are my go-to models in no particular order.

- [Mistral 7B Instruct 0.3](https://huggingface.co/mistralai/Mistral-7B-Instruct-v0.3) - This is an excellent model, at only 7b parameters it doesn’t require much memory and generates text very quickly. It has a large context window of 32,000 tokens.
- [Llama 3 - Instruct](https://huggingface.co/collections/meta-llama/meta-llama-3-66214712577ca38149ebb2b6) - This model family was released early 2024 by Meta with a fairly permissive license to use it for most people and companies. It comes in an 8b and 70b parameter variant. The 8B parameter variant performs quite well and can serve as a good starting point. The main limiting factor for me with these models is the 8192 token context window. This does have an unusually large token vocabulary though, so those 8192 tokens go pretty far. Meta have said there are more models coming in this family including ones with larger context windows.
- [Phi-3 Instruct](https://huggingface.co/collections/microsoft/phi-3-6626e15e9585a200d2d761e3) - This is a model family from Microsoft. It comes in 3.8B , 7B and 14B variants, with both 4k and 128k context windows. As of writing the 7B (small) model is not yet supported by Llama. These models perform surprisingly well and are seriously impressive. With the 128k context windows, I find I’m using the 14B model a lot for document reviews.
- [Mixtral 8x7B Instruct 0.1](https://huggingface.co/mistralai/Mixtral-8x7B-Instruct-v0.1) - This is a MoE model from Mistral. It’s comprised of 8 x 7b parameter experts. This requires a fair amount of ram, especially un-quantized, but inference speed is about the same as a 14b parameter model when generating. It also has a 32k context window. Truth be told, I don’t use this model much anymore. The latest 7 and 8b models are pretty close to not justify the memory requirements of this. I find I jump to the larger 70b class of models instead of this if I want better performance.

## Installing Llama.cpp

Now the model is downloading, this could take a while, so let’s next move to installing llama.cpp. We’re going to build this from the latest code on Github since it’s pretty easy, but there are [binary downloads available](https://github.com/ggerganov/llama.cpp/releases) if you prefer.

These instructions are for Ubuntu (and Ubuntu on WSL), but it’s a very similar process for Windows and Mac. You’ll need to ensure you have development tools installed. We did this before in the project setup for Ubuntu. More information on the other platforms can be obtained at the official [llama.cpp build instructions](https://github.com/ggerganov/llama.cpp?tab=readme-ov-file#build).

```bash
# Go into our project directory
cd chatbot

# Clone llama.cpp
git clone https://github.com/ggerganov/llama.cpp
cd llama.cpp

# Build llama.cpp
# -j $(nproc) means using all CPU cores available to build
make -j $(nproc)

# Install the requirements for some of the Llama.cpp tools
pip install -r requirements.txt

# Return to our project directory
cd ..
```

## Converting and Quantizing a model

Llama.cpp uses a custom model format called GGUF, or GPT-Generated Unified Format. You may occasionally run into the older format, GGML, GGUF is the successor and the one we’ll be focusing on. With that in mind, we need to convert from our downloaded format to this format first. After that we’ll run through a process called Quantization, which makes it the model smaller and more practical to run larger models on more modest systems.

## Convert from HuggingFace Transformers model to GGUF

First we need to get the model into llama.cpp’s preferred model format, GGUF. We can do this with the various convert scripts included with llama.cpp. Just point it to the directory of the model we downloaded and specify the output file.

There’s a few variations of the convert script from various starting formats. For our purposes we want to use `convert-hf-to-gguf.py` which converts from hugging face models to GGUF. You can optionally specify an output type for the weights, but for now it’s best to leave this at auto.

```bash
python llama.cpp/convert-hf-to-gguf.py Meta-Llama-3-8B-Instruct/ --outfile Meta-Llama-3-8B-Instruct.gguf --outtype auto
```

In the case of Mistral 0.3 and some others you may see an error regarding duplicate names. In this case the repository has 2 copies of the model, usually a mix of `consolidated.safetensors` and `model-0000*-of-00003.safetensors`. Simply delete the consolidated model with `rm consolidated.safetensors` and it will work as expected.

If you have downloaded a newly released model, it can take some time for llama.cpp to have support added or fully ironed out. Keep an eye on the [GitHub issues](https://github.com/ggerganov/llama.cpp/issues) and [pull requests pages](https://github.com/ggerganov/llama.cpp/pulls) for more information on the state of support for a given model.

### What does quantizing do?

As mentioned earlier, this is a method of compressing a model so it uses less RAM and memory bandwidth by discarding some precision. We can think of it as a form of [lossy compression](https://en.wikipedia.org/wiki/Lossy_compression). It is an optional step, but can reduce memory requirements and increase speed of a model, at the cost of varying impacts on the performance of the LLM.

I’m not going to cover the in-depth representation of IEEE floating point numbers, or some of the intelligent methods that have been developed to go from Half Precision 16 bit Floats to 4 bit integers, but I’d like you to have a reasonable level of intuition for what is happening. On a binary level what you are doing is reducing the precision of the numbers that can be stored. With each bit that is discarded you lose half the precision you can represent. This typically reduces the maximum number you can store, but by scaling the result you get the larger number range with reduced precision.

```jsx
0 1 2 3 4 5 6 7
*-*-*-*-*-*-*-* = 8 bits = 256 possible combinations
*-*-*-*-*-*-*   = 7 bits = 128
*-*-*-*-*-*     = 6 bits = 64
...
*               = 1 bit  = 2
```

If you imagine an integer number on a line, lets say 11. It can be represented accurately at full precision. But once we remove 1 bit, it no longer maps to a number we can precisely represent, and this only gets worse as we continue removing bits.

![Integer Quantization](/assets/posts/no-bs-llms/integer-quantization.png){: .enable-lightbox}

The original number then has to be rounded to the nearest number that can be represented in the new format. In the example above, after we’ve removed 4 bits of precision, we can’t store 11. We can only store 0 or 16, so we store 16 as it’s closer.

Behind the scenes on the newer quantization methods there are tricks to preserve some of this precision, minimizing loss, but ultimately precision still has to be discarded as part of the quantization process.

For some applications, this kind of quantization would be catastrophic, but as it turns out LLMs are remarkably resilient to this kind of compression. That’s not to say there are no impacts and you should only use quantized models, but they definitely have a useful purpose and are great for running larger models on more constrained or consumer level hardware. Some models can go from 16 bits per weight down to 4 bits per weight without suffering catastrophic impacts. [Some research is even looking at training LLMs at 1-2bits per weight](https://huggingface.co/papers/2402.17764) with impressive results!

### Quantization Settings

The [details of the quantization settings are naturally quite deep](https://github.com/ggerganov/llama.cpp/pull/1684), but a good write up on some of the various methods supported currently is [available here on Reddit.](https://www.reddit.com/r/LocalLLaMA/comments/1ba55rj/overview_of_gguf_quantization_methods/)

We’ll focus on the K-Quants method which uses a mixed precision, encoding some parts of the model at lower precision, and some at higher precision since there are different parts of the model that are more important than others for accuracy. This mix of precision allows the model to maintain a higher level of performance while still achieving a better overall size reduction.

At a top level we can break down some of the more interesting predefined quantization levels like so:

```jsx
Q<Target Bits Per Float>_K_<Size>
```

Where:

- `<Target Bits Per Float>` defines the main size of the majority of the weights Remember, lower numbers will result in smaller models, but will have greater impacts on the performance.
- `<Size>` allows mixed precision on the float size for segments of the model to preserve performance while still minimising memory. For example this may allow a Q5 model to have some weights, some more important areas of the model, at 6bits to improve performance. This is typically `S` for small, `M` for medium or `L` for large.

If you browse a bunch of models from TheBloke, he has done benchmarking on the various quant levels on all the models processed, [such as the Llama2 quantized version here](https://huggingface.co/TheBloke/Llama-2-7B-GGUF), and it seems one of the better tradeoffs for size and performance is Q5_K_M, which is what we’ll be using for our example. Feel free to experiment for your use case though. Your target system may be faster or slower depending on the quantization method chosen, and your application may or may not tolerate the performance/quality loss.

For a comprehensive list of available quantization methods available to you, you can run the below command for a list:

```bash
./llama.cpp/llama-quantize --help
```

### Quantize

Remember that this is an optional step, but if you want to quantize your model it’s a single line. This is a relatively quick process. On my machine it takes 2-3 minutes of CPU time for a 7b model.

```bash
llama.cpp/llama-quantize Meta-Llama-3-8B-Instruct.gguf Meta-Llama-3-8B-Instruct-q5_k_m.gguf Q5_K_M
```

### Convert to GGUF and Quantize in a single step

You can do both of these steps at once with a single command if you are happy to just use Q8, although doing it separately is nice because you have more options to choose quantization level.

```bash
python llama.cpp/convert-hf-to-gguf.py Meta-Llama-3-8B-Instruct/ \
  --outfile Meta-Llama-3-8B-Instruct-q8.gguf \
  --outtype q8_0
```

## Let’s try the model

So now we have a model converted and quantized, we can use llama.cpp to start generating text. The `llama-cli` program from llama.cpp will just start generating random text. We can run this and get an idea of performance and make sure the model is working. We'll also specify the `-n` parameter to limit the length of the output.

```bash
llama.cpp/llama-cli -m Meta-Llama-3-8B-Instruct-q5_k_m.gguf -n 100
```

Now we can use the `llama-simple` program to give it a specific input with the `-p` parameter.:

```bash
llama.cpp/llama-simple -m Meta-Llama-3-8B-Instruct-q5_k_m.gguf -n 20 -p "What is the capital of Australia?"
```

I encourage you to have a look through the other programs llama.cpp comes with, but for now we know it’s working and we can move on to building our first app.

## Let’s build the first basic chat-bot

Ok, so we have a model, everything is working, we’re familiar with lots of the jargon. Now we get to have some fun and experiment with the LLM.

### Installing Llama-cpp-python

Ok, I lied, we need one more thing. We need to install llama-cpp-python for our first experiments in python.

```bash
pip install llama-cpp-python
```

### Exploring with Python

Start a new file called [chatbot1.py](http://chatbot1.py) and we’ll start pasting some of these snippets in there.

### Load the model

```python
# Import the Llama class from llama-cpp-python
from llama_cpp import Llama
# We'll use pprint to more clearly look at the output
from pprint import pprint

# Create an instance of Llama to load the model
# model_path - The model we want to load
llm = Llama(
    model_path="Meta-Llama-3-8B-Instruct-q5_k_m.gguf",
)

print("Model loaded")
```

### First output

You can generate a text by generating a “completion” with the LLM using either the `llm` variable as a function, or using `llm.create_completion()` This just does straight generation and next token prediction, but works reasonably well in a Q&A format for our first example.

```python
output = llm(
    "Q: Name the planets in the solar system? A: ",  # Prompt
    max_tokens=128,  # Generate up to 128 tokens
    echo=True  # Echo the prompt back in the output
) 

print("Response generated:")
pprint(output)
```

You can now run the program with `python chatbot1.py`

In the response we can see that llama.cpp generates quote a verbose output during generation, but when we finally get our response we see a dict/json response like this. Please note your output may be different due to model, as well as some LLM parameters we’ll cover in the next article.

```python
{'choices': [{'finish_reason': 'length',
              'index': 0,
              'logprobs': None,
              'text': 'Q: Name the planets in the solar system? A: \n'
                      'The solar system comprises of eight major planets and '
                      'they are named as Mercury, Venus, Earth, Mars, Jupiter, '
                      'Saturn, Uranus and Neptune. Besides these planets, '
                      'there are also minor planets called asteroids, dwarf '
                      'planets like Pluto and the celestial body known as the '
                      'Sun at the center of this solar system which is '
                      'considered to be a star itself.\n'
                      '\n'
                      'Q: How many planets are in our solar system? A: \n'
                      'Our solar system consists of eight major planets along '
                      'with the Sun, Earth, Mercury, Venus, Mars, Jupiter, '
                      'Sat'}],
 'created': 1712550178,
 'id': 'cmpl-8dbbd002-902f-4339-a6a6-b07dd86bb08e',
 'model': 'neuralchat7b-q5_k_m.gguf',
 'object': 'text_completion',
 'usage': {'completion_tokens': 128, 'prompt_tokens': 14, 'total_tokens': 142}}
```

You can see in the `choices` array entry 0, that there is a `text` field that contains both our initial prompt, and the completed output from the LLM. We can also see a few more references to tokens, what are they?

Now looking at this response I see it finished the answer and then started a new question. It’s common for either the answer to get cut off, or the LLM starts generating additional questions. We can fix that with 2 changes, increasing the `max_tokens`, where None will generate the maximum amount (defined by the context length) and setting a stop sequence of characters, in this case a new question prompt. We can also fix that by following the models preferred formatting, also called it’s template, which we’ll cover later.

```python
output = llm(
    "Q: Name the planets in the solar system? A: ",
    max_tokens=None,  # This will keep generating up to the full context window
    stop=["Q:"], # Stop generating at new questions
    echo=True
)
```

It would be wise to keep a reasonable limit on `max_tokens` though to reduce wasted compute, long generation times and reduce costs if you move to a hosted LLM service.

We can also just explore this is currently just completing text by giving it a non-Q&A prompt.

```python
output = llm(
    "The cat sat on the ",  # Prompt
    max_tokens=128,  # Generate up to 128 tokens
    echo=True  # Echo the prompt back in the output
)
```

```python
Response generated:
{'choices': [{'finish_reason': 'length',
              'index': 0,
              'logprobs': None,
              'text': 'The cat sat on the 13th floor, watching the world go by '
                      'through the window. She was a sleek black feline with '
                      'piercing green eyes and a mischievous grin. She had '
                      'been living in this apartment for as long as she could '
                      'remember, and she knew every nook and cranny of it.\n'
                      '\n'
                      'As she sat there, she noticed something strange. The '
                      'lights in the hallway were flickering, and the shadows '
                      'on the wall seemed to be moving. At first, she thought '
                      'it was just her imagination, but as she watched, the '
                      'shadows began to take shape.\n'
                      '\n'
                      'It looked like a figure, tall and gaunt, with eyes that '
                      'glowed like'}],
 'created': 1717307379,
 'id': 'cmpl-79694c1d-6d24-4c69-ba41-a0f71a21498f',
 'model': 'Meta-Llama-3-8B-Instruct-q5_k_m.gguf',
 'object': 'text_completion',
 'usage': {'completion_tokens': 128, 'prompt_tokens': 7, 'total_tokens': 135}}
```

Well, that was an unexpected response! I was definitely expecting more along the lines of “The cat sat on the mat…”. Goes to show you how cool some of these local and small models can be. As you can see the LLM just started generating a story based on the initial few words, and didn’t behave as a Q&A assistant.

### Introducing Chat Completions

To move towards a more nicely formatted and behaving Q&A assistant, we’ll use Chat Completions.

To use this we need to have a more structured set of data. First, we’ll tell the llama class how to format the chat prompts for us. I’ll use `llama-3` here, but there are quite a number and the right one to use will depend on your model. You can usually find this information on the models HuggingFace repo. You can also leave out this parameter and one will be guessed from the metadata. If you put an invalid one in this field, it’ll generate an exception and give you a list of the currently supported chat templates. We’ll be exploring the chat templates in more depth in the next article.

```python
llm = Llama(
    model_path="Meta-Llama-3-8B-Instruct-q5_k_m.gguf",
    chat_format="llama-3",
)
```

Next, we’ll define an array of dictionaries which can contain our chat history. This is what will be formatted by the chat template in the llama class.

```python
messages_history=[
        {
            "role": "system",
            "content": "You are a helpful teacher who is teaching students about astronomy and the Solar System."
        },
        {
            "role": "user",
            "content": "Name the planets in the solar system?"
        }
    ]
```

Immediately you’ll notice a few new things here: roles, and a system prompt. We’ll look at these again as we also look at the output. So lets finish our example by changing the call to use `create_chat_completion`

```python
output = llm.create_chat_completion(
    messages=messages_history,
    max_tokens=128,  # Generate up to 128 tokens
)
```

The response we get is this:

```python
{'choices': [{'finish_reason': 'stop',
              'index': 0,
              'logprobs': None,
              'message': {'content': 'In our Solar System, there are eight '
                                     'major planets arranged in order from the '
                                     'sun: Mercury, Venus, Earth, Mars, '
                                     'Jupiter, Saturn, Uranus, and Neptune. '
                                     'These planets can be further classified '
                                     'into two categories - the inner or '
                                     'terrestrial planets (Mercury, Venus, '
                                     'Earth, and Mars) and the outer gas '
                                     'giants (Jupiter, Saturn, Uranus, and '
                                     'Neptune).',
                          'role': 'assistant'}}],
 'created': 1712568572,
 'id': 'chatcmpl-83c89fbd-425c-48a1-87b7-d593462fef0c',
 'model': 'neuralchat7b-q5_k_m.gguf',
 'object': 'chat.completion',
 'usage': {'completion_tokens': 100, 'prompt_tokens': 69, 'total_tokens': 169}}
```

We can see that this still generates a choices array, but instead of `text` we have a `message` field which contains content and role, just like the ones we specified in the `messages_history` array.

So that means we have 3 roles:

- System - How we initially instruct the LLM chatbot to behave
- User - The inputs from the user
- Assistant - The LLM responding to the user inputs.

Just a quick note on the system prompt. While many, perhaps most, models support a system prompt, there are some notable examples that weren’t trained with a System prompt, such as Google’s Gemma model. In these cases it won’t error, but it probably won’t respect the system token as well as you’d hoped, and you are better off adding the system prompt into the first user prompt. We’ll cover this more in depth in the next article where we explore chat templates in more detail.

## Full Chatbot Example

Now we have a basic understanding of how these work, we can start putting these together in a chatbot loop.

```python
from llama_cpp import Llama

# Load the model
llm = Llama(
    model_path="Meta-Llama-3-8B-Instruct-q5_k_m.gguf",
    chat_format="llama-3",
)

# Begin the message history array, we'll start with only the system prompt, as we'll now prompt the user for input
messages_history=[
        {
            "role": "system",
            "content": "You are a helpful teacher who is teaching students about astronomy and the Solar System."
        },
    ]

# A little util function to pull out the interesting response from the LLMs chat completion response
# This just pulls out the dict with the content and role fields.
def get_message_from_response(response):
    """Get the message from the response of the LLM."""
    return response["choices"][0]["message"]
    
def add_user_message(message):
    """Add a user message to the message history."""
    messages_history.append(
        {
            "role": "user",
            "content": message
        }
    )
    
# A function to print the entire message history, which will allow us to ignore some of the llama.cpp output
def print_message_history():
    """Print the full message history."""
    print("===============================")
    for message in messages_history:
        print(message["role"], ":", message["content"])

# Chat loop
while True:
    # Get a new user input
    user_message = input("(Type exit to quit) User: ")

    # Check if the user has tried to quit
    if user_message.strip() == "exit":
        break

    # Add the user message to the message history
    add_user_message(user_message)

    # Ask the LLM to generate a response from the history of the conversation
    llm_output = llm.create_chat_completion(
        messages=messages_history,
        max_tokens=128,  # Generate up to 128 tokens
    )

    # Add the message to our message history
    messages_history.append(get_message_from_response(llm_output))

    # Print the full conversation
    print_message_history()

    
print("Chatbot finished - Goodbye!")
```

And that’s it. We now have a working chat-bot! You can see the full source code on [GitHub here](https://github.com/GDCorner/no-bs-llms/blob/main/article1/chatbot1.py).

## Coming Up Next

[In the next article]({% link _posts/no-bs-llms/2024-06-12-NoBSIntroToLLMs-2-DivingDeeper.md %}) I’m going to dive into:

- OpenAI compatible APIs and client/server architecture for LLMs
- Streaming generation
- system prompts
- chat templates
- Generation settings like context and temperature

In the meantime I’m going to leave a list ideas of things to try and experiment with.

## Exercises for the Reader

- Recompile Llama.cpp with [CUDA](https://github.com/ggerganov/llama.cpp?tab=readme-ov-file#cuda), [Metal](https://github.com/ggerganov/llama.cpp?tab=readme-ov-file#metal-build), or a [BLAS](https://github.com/ggerganov/llama.cpp?tab=readme-ov-file#blas-build) backend.
- Try different models
- Try different quantization methods
- Try changing the system prompt. Ask it to respond in only capital letters.
- Change the system prompt to read a character sheet from a character.txt file

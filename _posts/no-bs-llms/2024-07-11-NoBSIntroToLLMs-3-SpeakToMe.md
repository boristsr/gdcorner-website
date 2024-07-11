---
layout: post
title:  "#3 - Speak To Me! (TTS & STT) - No BS Intro To Developing with LLMs"
date:   2024-07-11 15:20:13 +1100
tags: [ubuntu, llms, rag, no-bs, python, llama.cpp, stt, tts]
comments: true
image: "/assets/posts/no-bs-llms/no-bs-llms-ogimage.png"
description: "The third part of the No BS guide to getting started developing with LLMs. We'll explore processing audio and using text to speech and speech to text engines to open up new doors for interacting with LLMs and processing data."
categories: blog
menubar_toc: true
series: no_bs_llms
---

Welcome back to the No BS series on LLMs. Today we’re going to take a fun detour from LLMs and work with some audio processing. This is an important topic since so much of our language is communicated verbally. Being able to process recordings such as meeting recordings and videos as well generate audible responses, such as answers, summaries, or even your own personal morning news podcast will be very useful.

This isn’t going to be a super deep dive into DSP and audio, but rather just introduce you to some of the tools and concepts. If you’d like a deep dive into signals analysis and processing then checkout [The Scientist and Engineer’s Guide to Digital Signal Processing](http://www.dspguide.com/).

## Intro To Working With Audio

Working with audio can seem daunting if you haven’t done it before, and it is naturally a very deep topic, but for our purposes it’s pretty quick to get up to working speed with it.

![By Д.Ильин: vectorization - File:Signal Sampling.png by Email4mobile (talk), CC0, https://commons.wikimedia.org/w/index.php?curid=98587159](/assets/posts/no-bs-llms/signal_sampling.svg)
[By Д.Ильин: vectorization - File:Signal Sampling.png by Email4mobile (talk), CC0, https://commons.wikimedia.org/w/index.php?curid=98587159](https://commons.wikimedia.org/w/index.php?curid=98587159)

To represent a continuous signal like an audio waveform digitally we need to break it down into discrete (or individual) values. Audio is represented in digital systems as a series of intensity or strength values. An individual measured value is called a **sample** or a **frame** in the case of the audio library we’ll be using. These samples are are taken at regular intervals which is usually expressed in **hertz** (often abbreviated as `hz`) which means samples per second. This is called the **sample rate** or **sampling rate**. The resolution or size of the samples is called the **bit depth**, for example 8, 16 and 24 bits are common.

Mono Audio is a single series of values to represent 1 waveform. Imagine a single microphone, or a single speaker. Stereo is 2 sets of these series of values, for the left and right speakers. Having multiple microphones can have advantages, especially in preprocessing audio. For example with some clever DSP techniques you can use multiple microphones to find the direction of sound, reduce or eliminate noise and so on. All of those topics are complex and out of scope for this article though, see the book I recommended earlier for a deeper look into Digital Signals Processing. 

Audio can be compressed and decompressed using a [**codec**](https://en.wikipedia.org/wiki/Codec), you are likely familiar with the popular ones like AAC, MP3, and so on.

For our purposes we’re going to stick with uncompressed mono audio, meaning there is only 1 channel or series of values, and we don’t need to deal with a codec library at the same time.

### Recording Audio

To ensure our app works on most operating systems we’ll use PyAudio, which provides a nice simple interface to record and play audio with.

We won’t dive into device selection in this series. I’m going to assume you only have 1 input and 1 output audio device, or that you’ve appropriately set the default audio devices in your system settings.

Once again, on Ubuntu we need to install a little more. [If you need a refresher on the setup so far checkout article 1]({% link _posts/no-bs-llms/2024-06-12-NoBSIntroToLLMs-1-GettingStarted.md %}). We need the development package for Python 3.11, as well as [PortAudio](https://www.portaudio.com/) which is what PyAudio uses behind the scenes, and PyAudio is what we’ll be using in Python.

```bash
# Ensure our virtual environment is active
source .venv/bin/activate

sudo apt-get install python3.11-dev portaudio19-dev
pip install pyaudio
```

Now to record audio in python we first create a PyAudio object which initialises it for us.

```python
import pyaudio

# Instantiate PyAudio
pyaudio_instance = pyaudio.PyAudio()
```

Now we need to open a stream for recording from the microphone

```python
stream = pyaudio_instance.open(format=SAMPLE_BIT_DEPTH,
                channels=NUM_CHANNELS,
                rate=SAMPLE_RATE,
                frames_per_buffer=CHUNK_SIZE,
                input=True)
```

Let’s walk through that quickly, we’ve covered most of these concepts in the intro to audio section. `format` allows us to specify the datatype of the samples, in this case how many bits per sample. `channels` is where we can set how many waveforms we want, such as mono, stereo etc. `rate` is the sampling rate in `hz` . With `input` we specify that this is an input, or a recording stream, for example we want information from the microphone.

The final interesting value is `frames_per_buffer` which is how many samples we want to receive at a time. We won’t be receiving individual samples at a time, but rather chunks or segments of audio. Smaller chunks can reduce latency of processing however if you choose a value that’s too small or don’t keep up with the throughput of the system it can lead lead to skipped audio or if you are streaming straight back out it may sound choppy or weird. Using a value too high may lead to long latency before you can react to audio events, like say if you are trying to stream audio straight to another source. You need to choose a balance for your particular application.

The values I use for this demo are below. I’ve specifically chosen these values for working with Whisper which will do the speech to text conversion for us, but we’ll cover that in a few sections time.

```python
CHUNK_SIZE = 1024  # Record in chunks of 1024 samples
SAMPLE_BIT_DEPTH = pyaudio.paInt16  # 16 bits per sample
NUM_CHANNELS = 1
SAMPLE_RATE = 16000  # Record at 16khz which Whisper is designed for
                     # https://github.com/openai/whisper/discussions/870
RECORDING_LENGTH = 10
```

Now the stream is open we need to receive this data.

```python
chunks = []  # Initialize list to store chunks of samples as we received them

TOTAL_SAMPLES = SAMPLE_RATE * RECORDING_LENGTH

for i in range(int(TOTAL_SAMPLES / CHUNK_SIZE) + 1):
    data = stream.read(CHUNK_SIZE)
    chunks.append(data)
    
# Join the chunks together to get the full recording in bytes
frames = b''.join(chunks)
    
# Trim the recorded frames to the desired recording length
# The frames were received as bytes, so we need to account for 2 bytes per sample
frames = frames[:TOTAL_SAMPLES * 2]
```

In this example we are recording for 10 seconds `RECORDING_LENGTH`, which means the range for the loop is `Samples per second * Number of Seconds` then finally we divide that by our segment or chunk size. Basically, we read enough chunks of audio to cover our desired recording length.

Because we record in chunks, we often won’t be able to get the exact number of samples desired, so we’ll try and get more samples than required, and then trim it down. Alternatively, you could also just pad it with zeroes. you can see in `chunks` we are storing each chunk of audio as a new entry. That means we need to reassemble the full audio stream afterwards which is where we create the `frames` variable and do the bytes join to append each of those chunks into a new bytes object.

Finally, we close up the stream and terminate our PyAudio instance.

```python
# Stop and close the stream 
stream.stop_stream()
stream.close()
# Release PortAudio
p.terminate()
```

### Wave Files

Now we have the audio recorded to an in-memory buffer, what do we do with it? Well let’s start by writing it to file. Wave files are a common uncompressed file format. Python has an inbuilt library for working with them. This will be useful for testing so we don’t have to keep speaking and waiting for the recording time every time we want to test a new iteration of our program.

To write to a wave file we simply `import wave`, and then can write a new wave file with a few lines of code.

One thing to be careful of is that we’ve dealt with sample resolution/depth in terms of bits so far, but waves store this as a number of bytes, so we just need to be careful to appropriately convert between the two.

```python
# Python inbuilt library for dealing with wave files
import wave
# Open our wave file as write binary
wf = wave.open(filename, 'wb')
# Set the number of channels to match our recording
wf.setnchannels(NUM_CHANNELS)
# Set the bit depth of our samples. Waves store the sample
# size as bytes, not bits, so we need to do a conversion
wf.setsampwidth(pyaudio_instance.get_sample_size(SAMPLE_BIT_DEPTH))
# Set the sampling rate
wf.setframerate(SAMPLE_RATE)
# Then write out the samples we recorded earlier
wf.writeframes(frames)
# Close the file
wf.close()
```

Reading a wave file is equally simple. Once again, being careful about bits vs bytes when dealing with sample width.

```python
with wave.open(filename, 'rb') as wf:
		# Careful, waves store the bitdepth as bytes
    SAMPLE_BYTE_DEPTH = wf.getsampwidth()
    # Bit depth can be obtained by converting like this
    SAMPLE_BIT_DEPTH = pyaudio_instance.get_format_from_width(wf.getsampwidth())
    NUM_CHANNELS = wf.getnchannels()
    # note again here that the wave lib calls samples frames
    # so the sample rate is called the frame rate.
    SAMPLE_RATE = wf.getframerate()
    # Read samples
    chunks = wf.readframes(CHUNK_SIZE)
```

### Playing Audio

Playing audio is pretty similar in reverse.

Once again we define a chunk size that we will use to send the audio in segments, as well as which file we’ll be reading

```python
CHUNK_SIZE = 1024
filename = "recording.wav"
```

Make sure we have a PyAudio instance

```python
# Instantiate PyAudio
pyaudio_instance = pyaudio.PyAudio()
```

Then we open the file for reading as binary.

```python
with wave.open(filename, 'rb') as wf:
```

We initialize a stream with the settings from the wave file. The key things are the sample width, the number of channels, and the sample rate.

```python
# Waves store bit depth as number of bytes, so we convert this to PyAudio format
bit_depth = pyaudio_instance.get_format_from_width(wf.getsampwidth())

# Open stream
stream = pyaudio_instance.open(format=bit_depth,
                                channels=wf.getnchannels(),
                                rate=wf.getframerate(),
                                output=True)
```

Now that the file is open, we can start reading chunks and sending them to the audio stream.

```python
# Play samples from the wave file in the same chunksize
while len(data := wf.readframes(CHUNK_SIZE)):
    stream.write(data)
```

And finally, we close the audio stream and terminate the PyAudio instance.

```python
# Close stream
stream.close()

# Release PyAudio system resources
pyaudio_instance.terminate()
```

You can see the [full examples of recording](https://github.com/GDCorner/no-bs-llms/blob/main/article3/audio-record-wave.py) and [playing audio on GitHub](https://github.com/GDCorner/no-bs-llms/blob/main/article3/audio-play-wave.py).

## Speech To Text with Whisper

For this component we’re going to use [Whisper from OpenAI](https://github.com/openai/whisper). This is a really great AI model that [comes in a variety of sizes](https://github.com/openai/whisper?tab=readme-ov-file#available-models-and-languages). The different sizes have different capabilities at various languages, and they also have different memory and processing requirements. There’s no right answer for which model you choose, it all depends on your needs.

There’s a few improvements to whisper available, like `faster-whisper` and `whisperx` however we’ll be sticking with raw Whisper for this series as once again we want to see a few more of the details of the technology and get below some of the abstractions.

Let’s install whisper

```bash
# Ensure our virtual environment is active
source .venv/bin/activate

pip install openai-whisper
```

### Recording the Audio for Whisper

Whisper has a few requirements. The first one is that audio sent to Whisper must have a sampling rate of 16,000hz. The settings for sampling frequency we used in the previous example on recording are fine for our requirements. Just double check you didn’t change any of those values. Run the previous example and record a question to a `recording.wav` file which is what we’ll test our next example on.

If you are transcribing an audio file or stream that doesn’t have a 16khz sampling rate, you need to resample the audio stream. There are a number of libraries and tools to do this, but it’s out of scope for this tutorial, rest assured it’s possible, and can be done with [ffmpeg](https://askubuntu.com/a/1306548) or [pytorch](https://pytorch.org/audio/stable/tutorials/audio_resampling_tutorial.html) as starting points.

### Sampling Theorem and Frequencies

The [sampling theorem](http://www.dspguide.com/ch3/2.htm) basically states that to accurately represent a signal, you need to sample the signal at twice the maximum frequency you want to receive or reconstruct. In our case this means that Whisper wants a sampling rate of 16,000hz which means it can receive a maximum frequency of 8khz, this is in the [HD Voice class of telephony bands](https://en.wikipedia.org/wiki/Wideband_audio). This is perfectly acceptable quality for voice which typically has [important frequencies in the 500-8khz range](https://www.dpamicrophones.com/mic-university/facts-about-speech-intelligibility).

### Running Whisper on a Wave File

Whisper is pretty simple to use if just transcribing a file. In just a few lines of code we can get some text out of it.

```bash
import whisper

# Load the model
model = whisper.load_model("tiny")
# Transcribe the audio file
result = model.transcribe("recording.wav")

# Print the transcribed text
print(result["text"])
```

That was pretty simple! As you can see Whisper automatically does the sample normalization for us if reading from a wave file. 

For our purposes, we only care about the “text” entry in the dict that is returned, but Whisper does some great stuff such as returning time stamps as well. I encourage you to explore the returned dict and think of all the excellent data annotation possibilities from such a feature.

You can [see the full example here](https://github.com/GDCorner/no-bs-llms/blob/main/article3/stt-whisper-wave.py).

### Running Whisper On An Audio Buffer

For a chat bot, we obviously don’t want to have to write everything to a wave file all the time. To solve this we’re going to work with an audio buffer in memory, but to do this we need to do some housekeeping ourselves on the audio stream.

So, using the same process to record audio before, we’ll create a simple `record_voice` function

```python
def record_voice(record_time=10.0):
    print('Please Speak Now...')

    stream = pyaudio_instance.open(format=SAMPLE_BIT_DEPTH,
                    channels=NUM_CHANNELS,
                    rate=SAMPLE_RATE,
                    frames_per_buffer=CHUNK_SIZE,
                    input=True)

    chunks = []  # Initialize list to store chunks of samples as we received them

    TOTAL_SAMPLES = int(SAMPLE_RATE * record_time)

    for i in range(int(TOTAL_SAMPLES / CHUNK_SIZE) + 1):
        data = stream.read(CHUNK_SIZE)
        chunks.append(data)

    # Join the chunks together to get the full recording in bytes
    frames = b''.join(chunks)

    # Trim extra samples we didn't want to record due to chunk size
    frames = frames[:TOTAL_SAMPLES * 2]

    # Stop and close the stream 
    stream.stop_stream()
    stream.close()

    print("Recording complete")
    return frames
```

This function simply records audio as before and returns the full set of samples. Now we need to normalize these samples from int16’s which have a range of `-32678` to `+32677` and convert to floats with a range of `-1.0` to `+1.0`. This can be done quite easily with numpy and simply dividing by `32678`.

```python
def convert_audio_for_whisper(samples):
    #samples is an ndarray and must be float32
    whisper_samples = np.array([], dtype=np.float32)

    # Make a numpy array from the samples buffer
    new_samples_int = np.frombuffer(samples, dtype=np.int16)
    # Convert to float and normalize into the range of -1.0 to 1.0
    new_samples = new_samples_int.astype(np.float32) / 32768.0

    whisper_samples = np.append(whisper_samples, new_samples)

    return new_samples
```

So now we have an array of samples as `floats` that are in the expected range of values. Now we can use whisper.transcribe just like before.

```python
samples = record_voice(RECORDING_LENGTH)
whisper_samples = convert_audio_for_whisper(samples)

# Load the whisper model
model = whisper.load_model("tiny")

# Transcribe the audio samples
transcription_result = model.transcribe(whisper_samples)

# Print the transcription
print(transcription_result["text"])
```

That’s all we need from Whisper for a simple chat bot.  Whisper is very powerful, and there are a number of models and model sizes that better match different use-cases.

If you want to look further into Speech-To-Text (STT), I recommend checking out these projects:

- [Faster-Whisper](https://github.com/SYSTRAN/faster-whisper) - A re-implementation of Whisper that’s faster and uses less memory
- [WhisperX](https://github.com/m-bain/whisperX) - A Library built on top of Faster-Whisper that provides extra functionality like Voice Activity Detection and Speaker Diarization. These are useful for only recording when the user has a question, and for separating individual speakers.
- [Silero VAD](https://github.com/snakers4/silero-vad) - Another library for Voice Activity Detection
- [openWakeWord](https://github.com/dscripka/openWakeWord) - A library for identifying activation or wake words to automatically begin recording for transcription

## Text To Speech with Piper

As with all tasks for building a chat bot, the choices of Text-To-Speech (TTS) engines and models here are plentiful. We’re going to stick with a local model, and I’ve chosen [Piper](https://github.com/rhasspy/piper) since it’s designed for running on everything right down to a Raspberry Pi. This means it’s light weight, and runs basically anywhere. I found that the voices aren’t particularly expressive/emotive, however the clarity of the voices are surprisingly great and natural given the runtime constraints.

Once again need to make sure we are using Python 3.11 for now. Refer to Article 1 for setting up the python environment if you need a refresher.

To install piper run the following:

```bash
# Ensure our virtual environment is active
source .venv/bin/activate

# Install piper-tts
pip install piper-tts
```

### Download a voice

Piper has a large number of pre-trained voices available. You can browse through samples of the voices available here [https://rhasspy.github.io/piper-samples/](https://rhasspy.github.io/piper-samples/)

Once you’ve chosen a voice you like, you can go to the voices page in the repository and find the download links. You need to ensure you download both the `.onnx` file and the `.onnx.json` files.

[https://github.com/rhasspy/piper/blob/master/VOICES.md](https://github.com/rhasspy/piper/blob/master/VOICES.md)

I’ll be using `en_US-hfc_female-medium` so you need to download both the model and the config json files for this voice, or adjust the model string in the examples.

### Speak To Me

First we load the model by importing `PiperVoice` and then calling `.load` with our model name.

```python
from piper import PiperVoice

#Make sure the json file is next to this model
piper_model = "en_US-hfc_female-medium.onnx"
# Load the voice model
voice = PiperVoice.load(piper_model, config_path=f"{piper_model}.json")
```

Our sample text to generate will be an extract of “A Tale Of Two Cities” by Charles Dickens. This is a reasonably long sample so we can see how quickly this generates.

```python
text = "It was the best of times, it was the worst of times, it was the age of wisdom, it was the age of foolishness, it was the epoch of belief, it was the epoch of incredulity, it was the season of Light, it was the season of Darkness, it was the spring of hope, it was the winter of despair, we had everything before us, we had nothing before us, we were all going direct to Heaven, we were all going direct the other way—in short, the period was so far like the present period, that some of its noisiest authorities insisted on its being received, for good or for evil, in the superlative degree of comparison only."
```

Generating Audio is quite straight forward. We provide some parameters for the voice synthesizer and then simply pass in our text we wish to generate.

```python
synthesize_args = {
        "sentence_silence": 0.0,
    }

print("Generating Message")
#open an in-memory wave file
#synthesize the text to the wave file
message_audio_stream = voice.synthesize_stream_raw(text, **synthesize_args)

# message audio is bytes
message_audio = bytearray()

# Grab every byte of audio generated and add it to our message_audio array
for audiobytes in message_audio_stream:
    message_audio += audiobytes

# Finally convert to a bytes object
message_bytes = bytes(message_audio)
```

Now we have a bytes object with all of our audio, it’s just like playing a wave file. The model we downloaded outputs at a predetermined sample rate, based on the training of the model. So we need to ensure we read this from the settings of the model.

```python
SAMPLE_BIT_DEPTH = pyaudio.paInt16  # 16 bits per sample
NUM_CHANNELS = 1 # mono
pyaudio_instance = pyaudio.PyAudio()

# Open a stream to output the audio. Notice we get the sample rate from the settings of the loaded model.
output_stream = pyaudio_instance.open(format=SAMPLE_BIT_DEPTH,
                                            channels=NUM_CHANNELS,
                                            rate=voice.config.sample_rate,
                                            output=True)
print("Playing Message")
output_stream.write(message_bytes)
```

So, it’s quite simple to get started generating and playing audio from text. You can [see the example for this here](https://github.com/GDCorner/no-bs-llms/blob/main/article3/tts-piper-bulk.py).

Now this is great and all, but this still requires that we generate all the audio at once before playing it. On a slower system, a long piece of text, or with a more complex TTS engine, this could have a very significant impact on the responsiveness of our chat bot. It’d be better if we streamed the playback 

Let’s refactor this a little, and make it play the audio as it generates.

We’re going to change the `for` loop where it retrieves the audio from the TTS engine and immediately pump it to the output stream.

```python
# Synthesize the audio to a raw stream
message_audio_stream = voice.synthesize_stream_raw(text, **synthesize_args)

# Larger chunk sizes tend to help stuttering here
CHUNK_SIZE = 4096

# message audio is in bytes
message_audio = bytearray()

for audiobytes in message_audio_stream:
    # We keep acruing audio until we have enough for a chunk
    message_audio += audiobytes
    while len(message_audio) > CHUNK_SIZE:
        # Once we have enough for a chunk (potentially multiple chunks)
        # we extract it from the buffer
        latest_chunk = bytes(message_audio[:CHUNK_SIZE])
        message_audio = message_audio[CHUNK_SIZE:]
        # Output the latest chunk to the audio stream
        output_stream.write(latest_chunk)

# Write whatever is left in message audio that wasn't large enough for a final chunk
output_stream.write(bytes(message_audio))
```

This now starts outputting audio as soon as we have enough data from the TTS engine to output a large enough chunk. You can see the [full example of this here on GitHub](https://github.com/GDCorner/no-bs-llms/blob/main/article3/tts-piper-stream.py).

## Putting it all together

Now we’ve learned how to work with audio in doing so we’ve built up a few different pieces of the puzzle of a voice chat bot. So far we’ve built these pieces:

- The text chat bot using the OpenAI API from the previous article
- A way to record audio from the microphone
- A way to transcribe audio using Whisper
- A way to generate speech from text

Let’s take the chat bot example from the end of the previous article, and lets add in the new pieces we built up today.

First, we need to import the new libraries.

```python
import whisper
import pyaudio
from piper import PiperVoice
```

Then at the beginning of the program we need to load the whisper model, and load the piper voice model, and initialize the PyAudio instance.

```python
# Open the whisper tiny model
model = whisper.load_model("tiny")

#Load the piper model
piper_model = "en_US-hfc_female-medium.onnx"
# We can't use CUDA on RPi, so forced off. Turn on if you'd like
voice = PiperVoice.load(piper_model, config_path=f"{piper_model}.json")

# Open a PyAudio instance
pyaudio_instance = pyaudio.PyAudio()
```

We’ll add in the functions we made for Recording Voice, Converting Audio For Whisper, as well as our default settings for audio

```python
## Voice Record Settings
CHUNK_SIZE = 1024  # Record in chunks of 1024 samples
SAMPLE_BIT_DEPTH = pyaudio.paInt16  # 16 bits per sample
NUM_CHANNELS = 1
SAMPLE_RATE = 16000  # Record at 16khz which Whisper is designed for
RECORDING_LENGTH = 10.0 # Recording time in seconds

def record_voice(record_time=10.0):
    print('Please Speak Now...')

    stream = pyaudio_instance.open(format=SAMPLE_BIT_DEPTH,
                    channels=NUM_CHANNELS,
                    rate=SAMPLE_RATE,
                    frames_per_buffer=CHUNK_SIZE,
                    input=True)

    chunks = []  # Initialize list to store chunks of samples as we received them

    TOTAL_SAMPLES = int(SAMPLE_RATE * record_time)

    for i in range(int(TOTAL_SAMPLES / CHUNK_SIZE) + 1):
        data = stream.read(CHUNK_SIZE)
        chunks.append(data)

    # Join the chunks together to get the full recording in bytes
    frames = b''.join(chunks)

    # Trim extra samples we didn't want to record due to chunk size
    frames = frames[:TOTAL_SAMPLES * 2]

    # Stop and close the stream 
    stream.stop_stream()
    stream.close()

    print("Recording complete")
    return frames

def convert_audio_for_whisper(samples):
    #samples is an ndarray and must be float32
    whisper_samples = np.array([], dtype=np.float32)

    # Make a numpy array from the samples buffer
    new_samples_int = np.frombuffer(samples, dtype=np.int16)
    # Convert to float and normalize into the range of -1.0 to 1.0
    new_samples = new_samples_int.astype(np.float32) / 32768.0

    whisper_samples = np.append(whisper_samples, new_samples)

    return new_samples
```

We’ll make a nice wrapper function for these to make it simple to get a new question from the user. This will help keep our chat loop nice and clear.

```python
def get_user_message_from_voice():
    samples = record_voice(RECORDING_LENGTH)
    whisper_samples = convert_audio_for_whisper(samples)
    transcription = model.transcribe(whisper_samples)
    return transcription['text']
```

We also need to add in our Speak Answer function using the streaming version of the TTS generation

```python
def speak_answer(text):
    print("Generating Message Audio")

    # Open stream
    output_stream = pyaudio_instance.open(format=SAMPLE_BIT_DEPTH,
                                            channels=NUM_CHANNELS,
                                            rate=voice.config.sample_rate,
                                            output=True)

    synthesize_args = {
            "sentence_silence": 0.0,
        }

    # Synthesize the audio to a raw stream
    message_audio_stream = voice.synthesize_stream_raw(text, **synthesize_args)

    # Larger chunk sizes tend to help stuttering here
    CHUNK_SIZE = 4096

    # message audio is bytes
    message_audio = bytearray()
    message_chunks = []

    for audiobytes in message_audio_stream:
        message_audio += audiobytes
        while len(message_audio) > CHUNK_SIZE:
            latest_chunk = bytes(message_audio[:CHUNK_SIZE])
            message_chunks.append(latest_chunk)
            output_stream.write(latest_chunk)
            message_audio = message_audio[CHUNK_SIZE:]

    # Write whatever is left in message audio that wasn't large enough for a final chunk
    output_stream.write(bytes(message_audio))

    # Close stream
    output_stream.close()
```

And now we add those into our chat loop. We will no longer accept text answers, but we’ll use the same `input` function to make it so the user needs to press enter to begin recording their next question.

```python
def main():
    # Chat loop
    while True:
        # Get a new user input
        text_input = input("Press enter to ask a question, or type 'exit' to quit: ")

        # Check if the user has tried to quit
        if text_input.lower().strip() == "exit":
            break
        
        user_message = get_user_message_from_voice()
        print("The user asked: ", user_message)
        
        # Add the user message to the message history
        add_user_message(user_message)

        # Generate a response from the history of the conversation
        llm_output = client.chat.completions.create(
            model="Meta-Llama-3-8B-Instruct-q5_k_m",
            messages=messages_history,
            stream=True
        )

        full_response = ""
        for chunk in llm_output:
            latest_chunk_str = chunk.choices[0].delta.content
            if latest_chunk_str is None:
                continue
            full_response += latest_chunk_str
            print(latest_chunk_str, end='', flush=True)

        # Force a new line to be printed after the response is completed
        print()
        speak_answer(full_response)

        add_assistant_message(full_response)

        # Print the full conversation
        print_message_history()

    # Release PortAudio
    pyaudio_instance.terminate()

    print("Chatbot finished - Goodbye!")
```

That’s it! We can now talk to our AI chat bot and have it speak back to us! You can [find this full example on GitHub here](https://github.com/GDCorner/no-bs-llms/blob/main/article3/full-chatloop.py).

## Going Further

As I stated in the first article, I don’t believe chat bots are the killer app (or at the very least the sole application) for LLMs but they’ve provided a great basis to explore a lot of the tech and surrounding technologies like audio processing. I think with what we’ve explored in this series there’s some great foundational knowledge to build on and start integrating other technologies and workflows. I’m leaving some ideas and projects for you to keep exploring below.

If you’d like to go further down the audio processing and DSP route, I highly recommend the book linked in the beginning sections,  [The Scientist and Engineer’s Guide to Digital Signal Processing](http://www.dspguide.com/) as a starting point which you can then use to explore all kinds of crazy expansions on audio processing from noise cancellation to speaker direction tracking.

### Project Ideas

- Expand this chat bot with voice activity detection and wake words.
- Improve the responsiveness of this chat bot by trying to split the streaming LLM generation at sentences and run the TTS asynchronously to avoid the delay of waiting for the entire LLM output.
- Make an automatic news reader that gathers the latest news, summarizes and produces a morning podcast for yourself.
- Make a tool that summarizes YouTube videos.
- Make a tool to generate after meeting email reports with action points and tasks for people based on the transcribed audio.
- Make a moderation bot to identify toxic, annoying or unwanted behavior in your chats and communities
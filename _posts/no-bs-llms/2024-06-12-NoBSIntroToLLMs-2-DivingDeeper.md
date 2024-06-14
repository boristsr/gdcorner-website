---
layout: post
title:  "#2 - Diving Deeper! - No BS Intro To Developing with LLMs"
date:   2024-06-12 15:20:13 +1100
tags: [ubuntu, llms, rag, no-bs, python, llama.cpp]
comments: true
image: "/assets/posts/no-bs-llms/no-bs-llms-ogimage.png"
description: "The second part of the No BS guide to getting started developing with LLMs. We'll explore connecting to an LLM host via a network API, using streaming for responses, usage statistics, generation settings, chat templates, and system prompts."
categories: blog
menubar_toc: true
series: no_bs_llms
---

Welcome back to the No BS exploration of LLMs! I'm excited to dive in once again. This article is a bit shorter as we have got over the initial learning hump of the models, runtimes and lots of the jargon involved in getting up to speed.

In this article we’ll explore connecting to an LLM host via a nework API, then we will begin using streaming for our responses so we can start showing the user information sooner. After that we’ll explore usage statistics and generation settings so we can tune the LLM responses a little bit. We’ll also look at Chat Templates and how chat histories are formatted for the LLM to understand them better. Finally we’ll cover system prompts and how we can get the LLM to do the tasks we want them to.

The first thing we’ll look at today is moving to separate out our LLM instance from our app. The advantage of this will be four-fold:

1. The server can serve more than just one app, and many users, leading to improved hardware utilization if we have more than one consumer of LLMs.
2. We can host the LLM on a much more powerful system than where we are running the app. For instance hosting the LLM on a server, while our app runs on a phone, Raspberry Pi, or laptop.
3. Faster iteration time of our application since we are not constantly loading and initializing the LLM every time we restart our chatbot.
4. When we want to swap out model, server app, or even scale up to using bigger models like GPT4, it’s a much smaller change to our application.

## Picking up where we left off

Just as a refresher, lets get back to our project directory and activate the virtual environment

```bash
# Go back to our chatbot directory where we left on in Article 1
cd chatbot

# Make sure we are in our virtual environment
source .venv/bin/activate
```

## OpenAI API

OpenAI made their [API specification open source](https://github.com/openai/openai-openapi), and as a result their API has fairly widespread support which will make it easy to switch hosts or providers quite easily. There are other APIs available and they vary by provider and runtime engine, but for our purposes OpenAI is a great starting point and is fairly widely supported.

### Starting Llama.cpp in Server mode

To run llama.cpp in Server mode, it’s as simple as the following command. Make sure to run this in a new terminal so we can still continue on with the rest of the examples.

```bash
# Start the server with our model
./llama.cpp/llama-server -c 0 -m Meta-Llama-3-8B-Instruct-q5_k_m.gguf
```

I specify `-c 0` here for an important reason. Llama.cpp defaults to using a 512 token context length. By specifying 0, it tells llama.cpp to use the context length specified in the model. If you go back to the source HuggingFace model, you can open `config.json` and look for the field entry `max_position_embeddings` . This was encoded into the GGUF when it was converted. We’ll look at context size more when we get to the settings in a few sections time, but for now just know that it’s basically the length of the chat history we can pass into the LLM to be considered when generating an answer.

### Using the OpenAI API

Now lets modify our example chat loop to now use the OpenAI API. Fire up a new terminal and activate the virtual environment

```bash
cd chatbot

# Make sure we are in our virtual environment
source .venv/bin/activate
```

Install the [OpenAI](https://pypi.org/project/openai/) package with pip.

```bash
pip install openai
```

We need to make a few changes to our existing chat bot example. Let’s copy the existing example into a new file where we can make our changes.

```python
cp chatbot1.py chatbot-openai.py
```

First we need to import some new classes from the `openai` package.

```python
# Remove the old imports
# from llama_cpp import Llama

# Import the OpenAI library
from openai import OpenAI, ChatCompletion
```

Next, we now need to create a client object through which we can make requests, rather than loading the model. Here we pass in the URL of where we are hosting the model. In this case we are just using `localhost`. Here is also where you’d pass in an API key for a secured service. In this case we don’t need a valid key for Llama.cpp, but we do need to specify one to keep the library happy.

```python
# Replace the old code
# Load the model
# llm = Llama(
#    model_path="Meta-Llama-3-8B-Instruct-q5_k_m.gguf",
#    chat_format="llama-3",
# )

# Connect to the LLM server
client = OpenAI(base_url="http://localhost:8080/",
                api_key="local-no-key-required")
```

Now, we change how we request a completion. Here we specify the model we’d like to use, in this case the one we loaded with the server. This is very useful for mixing models when you are using a service that supports multiple models.

```python
# Remove the old completion request
# llm_output = llm.create_chat_completion(
#     messages=messages_history,
#     max_tokens=128,  # Generate up to 128 tokens
# )

# Ask the LLM to generate a response from the history of the conversation
response = client.chat.completions.create(
    model="Meta-Llama-3-8B-Instruct-q5_k_m",
    messages=messages_history
)
```

Now the example is fetching request from via the OpenAI API, we need to make a few changes to how messages are handled, as they now come as a new object type.

First change is we need to adjust how we get the message from the response. So remove the `get_message_from_response` function and create a new one which gets the information we need from the new `ChatCompletion` object. More details on what’s in the [ChatCompletion object are available on the OpenAI documentation page](https://platform.openai.com/docs/api-reference/chat/object).

```python
def get_message_from_openai_response(response: ChatCompletion):
    chat_message = response.choices[0].message
    response = {
        "role": chat_message.role,
        "content": chat_message.content
    }
    return response
```

And finally change how we append the response to the chat history using this new function.

```python
# Add the message to our message history
messages_history.append(get_message_from_openai_response(llm_output))
```

And that’s it. Our chatbot now uses the OpenAI API. By changing the client object URL we can connect to a variety of other runtimes or services, and change models with relative ease. This is also great for us to iterate with, as it means we won’t be loading the model constantly.

You can see the [full code for this example now here.](https://github.com/GDCorner/no-bs-llms/blob/main/article2/chatbot-openai.py)

If you’d like to see more details on the [Chat Completion API, OpenAI have really good documentation on it here](https://platform.openai.com/docs/api-reference/chat/create).

## Streaming Generation

So far our application has been generating the full response before displaying it to the user. This leads to a long latency before the user sees anything which is not the greatest experience. Let’s change this now to use streaming generation. This will generate fragments or chunk and allow us to present part of the response to the user much more quickly.

Once again, lets copy our current chatbot to a new file where we can explore some more.

```python
cp chatbot-openai.py chatbot-streaming.py
```

First, lets tell the API to generate streaming chunks. Change the chat completions request to specify streaming.

```python
# Generate a response from the history of the conversation
llm_output = client.chat.completions.create(
    model="Meta-Llama-3-8B-Instruct-q5_k_m",
    messages=messages_history,
    stream=True
)
```

Now, how we handle this message is going to change quite a bit. We will no longer get a single response object with our usage data, and so on. Instead we will get a series of chunks via an Event Stream. Once again, you can see more details about what's in this response object on the [OpenAI documentation page for the Chat Completion Chunk Object](https://platform.openai.com/docs/api-reference/chat/streaming).

```python
for chunk in llm_output:
    print(chunk.choices[0].delta.content)
```

Running this now with `python chatbot-streaming.py` we can see that it appears we are getting single tokens at a time, and they are printing on their own line. This isn’t great, but since we’re going to turn this into a voice chatbot in the next article, we won’t spend a bunch of time doing this neatly, quick and dirty will do. Also we aren’t getting this message added to the history of our chat. Lets make sure we add this to the history now.

We’ll define a new function to add an assistant message to the history. We could refactor `add_user_message`, but for now I’d like to keep them separate to ensure we don’t make typos with participant names and hardcoded strings elsewhere in the program, so we’ll just make a new function.

```python
def add_assistant_message(message):
    """Add a user message to the message history."""
    messages_history.append(
        {
            "role": "assistant",
            "content": message
        }
    )
```

Now, when we are processing the streamed message chunks we’ll add them to a `final_response` string, and after there are no more chunks to receive, we’ll add this `final_response` to the message history. This also changes how we print the latest chunk, we don’t want a line feed at the end, and we don’t want it to buffer until we get a new line feed character, so we’ll specify an end string as a blank string and flush the stream on print.

```python
full_response = ""
for chunk in llm_output:
    latest_chunk_str = chunk.choices[0].delta.content
    if latest_chunk_str is None:
        continue
    full_response += latest_chunk_str
    print(latest_chunk_str, end='', flush=True)

# Force a new line to be printed after the response is completed
print()

add_assistant_message(full_response)
```

Running this example we can see we get our first response chunk back within seconds, rather than waiting for the whole response to be generated. This means we can start presenting this to the user straight away, making the experience feel much more responsive.

Once again, you can see the [full example after all these changes on Github here.](https://github.com/GDCorner/no-bs-llms/blob/main/article2/chatbot-streaming.py)

### Going Further With Streaming

OpenAI have written a fair bit of information about how to use their API and streaming, and it’s worth reading their [API docs which has some other examples](https://cookbook.openai.com/examples/how_to_stream_completions).

## Usage Statistics

Monitoring the usage stats is important for monitoring your costs, the most intensive parts of your system, and also monitoring your context window usage.

Monitoring costs may include monitoring the most high usage customers, a particular workflow that’s running too often or is unexpectedly high load.

Monitoring context usage is going to help you keep aware of one of the ways you can outgrow your chosen model. When your system begins to approach or exceed the context window you may end up chopping off parts of the context or losing reliability in your answers. We’ll cover the context window a bit more in a few moments.

We can get these out of the OpenAI pretty easily. First we update the completion API call with a new parameter, `stream_options` where we specify to include usage.

```bash
llm_output = client.chat.completions.create(
            model="Meta-Llama-3-8B-Instruct-q5_k_m",
            messages=messages_history,
            stream=True,
            stream_options={"include_usage": True}
        )
```

Now we have the server returning usage stats, lets make sure we handle them. The way Llama.cpp returns is a bit different to the OpenAI documentation. The documentation says the usage will be returned in a separate `ChatCompletionChunk` after the end of the response, where as the Llama.cpp server returns it as part of the stop reason message. No matter, we’ll make our code compatible with both.

As part of this we’ll also capture the reason the response was finished. This could be that the LLM signaled the answer was complete with a stop token, or it could be that the token generation limit was reached.

```bash
full_response = ""
request_usage = None
finish_reason = None
for chunk in llm_output:
    if chunk.usage:
        # If there is a usage object, lets store it
        request_usage = chunk.usage
    if len(chunk.choices) < 1:
		    # The API docs say that choices could be empty,
		    # so abort this loop iteration
		    continue
    if chunk.choices[0].finish_reason:
		    # If there is a finish_reason, lets store it too.
        finish_reason = chunk.choices[0].finish_reason
    latest_chunk_str = chunk.choices[0].delta.content
    if latest_chunk_str is None:
        continue
    full_response += latest_chunk_str
    print(latest_chunk_str, end='', flush=True)

print()

print("Stop reason: ", finish_reason)
print("Usage: ", request_usage)
```

Great, lets run it and ask a short question.

```bash
(Type exit to quit) User: What is the temperature on mars? Short answer only
The average temperature on Mars is around -67°C (-89°F).
Stop reason:  stop
Usage:  CompletionUsage(completion_tokens=15, prompt_tokens=43, total_tokens=58)

===============================
system : You are a helpful teacher who is teaching students about astronomy and the Solar System.
user : What is the temperature on mars? Short answer only
assistant : The average temperature on Mars is around -67°C (-89°F).
(Type exit to quit) User: exit
Chatbot finished - Goodbye!
```

Excellent, we can see in here that the reason it stopped was the language model output a stop token, which wrapped up the response. We can also see this caught the CompletionUsage object. This gives us 3 values:

- completion_tokens, or the number of tokens in the response.
- prompt_tokens, the number of tokens in submission to the LLM, so the chat history and so on.
- total_tokens, the sum of both of the previous values.

So these are all very helpful. For small hobby tests and projects you can probably ignore them, but as you move towards production I’d look to capture these in your analytics system in some way so you can start getting visibility on the system usage.

You can see the full example of [usage statistics here.](https://github.com/GDCorner/no-bs-llms/blob/main/article2/chatbot-usage-stats.py)

## Generation settings

Now we’re generating tokens in a more responsive fashion and we can iterate more quickly, lets play with some of the generation settings.

### Context Window Length

Context window length is the amount of information, number of tokens, we can feed into the LLM and generate at any one time. The means the query, any additional information, and the generated results needs to fit within the context length.

A larger context window will require more memory, but will also allow extra information to be fed into the LLM which is especially useful if you will be feeding in documents or enriching queries with RAG (Retrieval-Augmented Generation).

A model will be trained with a maximum context length. Making this setting too high will likely lead to poor results.

On the other hand, if your prompt is too long and generates too many tokens, you’ll either get an error, or your prompt will be sliced to include only what will fit into the context window. The telltale sign of this is the LLM appears to forget responses or lose what was being discussed.

***Flash Attention*** is a setting related to Context Window Length. It’s supported by llama.cpp on GPU backends, but it is currently slower on CPU. It is a faster and more memory efficient attention mechanism within the LLMs themselves. The practical impact of this is that it can be a bit of a speed boost, but more importantly, a dramatic reduction in memory for large context windows. It’s worth reading up on this and seeing if it’s worthwhile enabling for your purposes.

### Temperature

Temperature affects how the next predicted token is chosen from the predicted probability list. A value of 0.0 will always choose the most likely token, while a value closer to 2.0 will choose a more random token resulting in more creative outputs. Be warned though that setting the Temperature too high can produce inconsistent results and encourage hallucinations.

You would adjust temperature higher when you want your responses to be a bit more varied, or creative. You would adjust it to be lower when you want the results to be more accurate.

### Seed

This is the seed for the random number generator when choosing a token with some random sampling to due temperature settings. A consistent starting seed will produce the same output from the same input and same parameters.

You would specify a seed when you want your results to be the same answer for the same input, otherwise the same chat history could generate many different responses with no seed set.

### More parameters

There are a LOT of parameters that can affect generation, but these are some of the ones that you will likely tweak initially. For more information of parameters the [ollama docs have an interesting list](https://github.com/ollama/ollama/blob/main/docs/modelfile.md#valid-parameters-and-values).

## Chat Templates

Chat- and Instruct-tuned models, the kind we are using in this series, expect that the chat history is formatted in a particular way. Each model is a bit different. If you don’t format the chat history appropriately then you can expect to get strange results from the LLM.

The model publisher will usually give information on it’s expected template or format.

The Llama 3 instruct template looks like this.

```text
<|begin_of_text|><|start_header_id|>system<|end_header_id|>

{{ system_prompt }}<|eot_id|><|start_header_id|>user<|end_header_id|>

{{ user_msg_1 }}<|eot_id|><|start_header_id|>assistant<|end_header_id|>

{{ model_answer_1 }}<|eot_id|>
```

Lets break this down. It appears that the prompt is expected to begin with `<|begin_of_text|>`, then the rest is a repeating pattern of:

```text
<|start_header_id|>**system**<|end_header_id|>

**{{ system_prompt }}**<|eot_id|>
```

Where the “speakers” name is sandwiched between `<|start_header_id|>` and `<|start_header_id|>`. Then there are a few new line characters followed by the content of that prompt or reply, finished off with a `<|eot_id|>` And this is repeated for each message in the history.

The server will try and do this formatting for you, but there are ways to do this formatting manually and bypass the servers formatting. Why would you do this? Well, apart from curiosity on how all this works, there's a few practical reasons. For one, you may be working with a newly released model that loads correctly since it is a new instruct-tuned model from a supported base, but it uses a new or slightly changed prompting style. Another reason might be that for whatever reason you are using an API endpoint that doesn’t automatically do the formatting for you, and are required to do it yourself.

Naturally, a templating engine like [Jinja](https://github.com/pallets/jinja) would be a great tool to use here, but for simplicity of this example we’re going to just write it in pure Python. We won’t be adjusting our main chatbot to use this, this is just as a side quest to explore the templates concept. So lets take a copy of the chatbot and begin to make some changes.

```bash
cp chatbot-streaming.py chatbot-templates.py
```

First we’ll define a function that can format our chat history:

```python
def format_chat_llama3(message_history):
    START_BLOCK = """<|begin_of_text|>"""
    MESSAGE_BLOCK = """<|start_header_id|>{user_id}<|end_header_id|>

{message_text}<|eot_id|>"""
    ASSISTANT_START = """<|start_header_id|>{user_id}<|end_header_id|>

"""

    chat_str = START_BLOCK
    for message in message_history:
        chat_str += MESSAGE_BLOCK.format(
            user_id=message["role"],
            message_text=message["content"]
        )
    
    # Add the assistant start block ready for the assistant to begin replying:
    chat_str += ASSISTANT_START.format(user_id="assistant")
    return chat_str
```

Here you can see we have the initial start string in `START_BLOCK` and then the repeating message string in `MESSAGE_BLOCK`. Our chat history already uses the same names that Llama3 expects, but some LLMs have been tuned to expect different names for the roles, so this is also a natural point to substitute the names of roles to the names expected by the LLM.

One interesting thing to notice here is that we want to start the assistants reply with the correct metadata tokens/formatting. Remember in the first article that we discussed that LLMs are simply predicting the next token in a stream of text. By beginning the assistants reply block we ensure that the assistant replies properly as the assistant, and doesn’t attempt to fill in it’s own metadata tokens, and doesn’t attempt to further expand the users question, or behave in other strange ways.

Just to highlight one way this can show up, if you don’t add the assistant start block to the prompt sent to Llama3 it will begin it’s response with `assistant` followed by 2 blanks lines. This is wasted compute, token usage and also string manipulation overhead to remove it that you just don’t want to do.

Now, into our main function we can generate a fully formatted version of our chat history with a quick one liner, and we’ll print that for our own benefit.

```python
formatted_chat = format_chat_llama3(messages_history)

print("Formatted chat:")
print(formatted_chat)

```

### Example Formatted Chat

Here is an example chat after being formatted with the template.

```text
<|begin_of_text|><|start_header_id|>system<|end_header_id|>

You are a helpful teacher who is teaching students about astronomy and the Solar System.<|eot_id|><|start_header_id|>user<|end_header_id|>

What is the average temperature on mars? Give me a short answer please.<|eot_id|><|start_header_id|>assistant<|end_header_id|>

The average temperature on Mars is around -67°C (-89°F), but it can range from -125°C to 20°C (-200°F to 70°F) depending on the time of day and season!<|eot_id|><|start_header_id|>user<|end_header_id|>

Another short answer please: How long is a day on Mars?<|eot_id|><|start_header_id|>assistant<|end_header_id|>

A day on Mars, also known as a "sol", is approximately 24 hours and 37 minutes long!<|eot_id|><|start_header_id|>user<|end_header_id|>

Next question: What is the atmosphere made of?<|eot_id|><|start_header_id|>assistant<|end_header_id|>

```

### Generating with the Formatted Chat

Now we need to change how we generate the text. Since we don’t want the server to format our chat, we won’t use the `Chat Completions API`, we’ll just use the `Completions API`. We won’t use streaming for this example.

```python
# Generate a response from the history of the conversation
llm_output = client.completions.create(
    model="Meta-Llama-3-8B-Instruct-q5_k_m",
    prompt=formatted_chat
)

full_response = llm_output.content

add_assistant_message(full_response)
```

You can see the full example for doing our [own formatting here.](https://github.com/GDCorner/no-bs-llms/blob/main/article2/chatbot-templates.py)

## System Prompts

System prompts are useful for providing context, guidelines, rules and extra prompts on the expected responses to the LLM. You can even give the LLM a style of speaking or a character to portray!

Not all LLMs have been trained to accept a system prompt. The model won’t break if you send it one, but you may notice it isn’t particularly influential on the results you get from the LLM. In this case it’s recommended to just prepend the system prompt to the first user input.

A good prompt can include:

- A brief note about what kind of AI assistant it is, or it’s role
- What the goal of the AI should be
- Instructions on the expected output, and perhaps output formatting
- Some examples of the output or expected writing style

I want to shout out a really interesting project, [Fabric](https://github.com/danielmiessler/fabric). This project has collected, collated, and written some REALLY awesome prompts for a large variety of tasks. They even have a prompt to improve prompts! I definitely recommend looking through the prompts to get some ideas on some well written, well thought out, and well tested prompts. Huge Kudos to Daniel and the contributors to the project on the fantastic work.

As an example of a system prompt, here is a basic prompt I use to help me review my blog posts.

```bash
Please review my blog article. It is trying to be informative, engaging without being too formal. It should be concise, to the point, and not meander around with flowery language.

The article should be clear. The explanations should make sense, and provide enough context to the reader. If the explanations are unclear or inaccurate, please point them out.

The article should have a nice flow. The article should build on top of previously stated information. It should avoid jumping around and confusing the reader. If the flow is confusing, please let me know.

The article should be correct. If there are any inaccuracies, please point them out.

The article should be grammatically correct. If there are any grammar or spelling issues, please let me know.

If there are any incomplete sentences, or if i haven’t completed a section by accident, please let me know.
```

### Prompting Strategies

There are a number of tricks to getting the most out of your LLMs, these fall under “prompting strategies” and can include a number of techniques. I hate the term, but this is often referred to as “Prompt Engineering”. Some interesting ones are:

- Chain-of-Thought - where you ask the LLM to output some initial steps and intermediate information, in a way allowing it time to “think” about the answer before immediately generating tokens of the final answer.
- Few-Shot Prompting - Provide some examples about the expected output so the LLM can mimic the results.

There are a number of guides available for finding new strategies to improve LLM performance.  I find this one quite useful [PromptingGuide.AI](https://www.promptingguide.ai/)

### Agents

You’ll run into the term “agents” or “agentic systems” or “agentic workflow” often. At the most basic level these are simply different System Prompts organised into a workflow. For instance you may have a system prompt that is targeted at summarizing documents, perhaps called a **Summarizing Agent**, then the original document and the summary result get passed into another LLM step with a new system prompt that is focused on checking the accuracy of a summarization and determining summarization quality, lets call that a **QA or QC Agent**.

These agent focused prompts can get pretty powerful by having feedback loops, keeping separate chat histories that are relevant only to their individual tasks and having the LLMs determine which system prompt is needed next out of a list of available system prompts. You can even mix and match models and system prompts for the best pairing on a given task.

While there are a number of agent frameworks available, they are not essential for using agents, the power of these frameworks comes more from the utilities they provide around agents, like easily fetching and parsing documents and web searches, and some convenience methods around connecting these together. It’s perfectly possible to setup a quick agent workflow in [just a few tens of lines of code](https://www.youtube.com/watch?v=jLVl5V8roMU) by working with LLM APIs directly.

## Wrap Up

That’s all for today. That was much shorter than the first article! Let’s recap what we’ve covered today:

We’ve explored using **web APIs** to interact with **remote servers hosting LLMs**. This allows us to:

- Iterate more quickly
- Host the LLM on a more powerful system
- Switch between hosts/providers easier

Next we explored **Streaming generation** which can used to reduce latency in requests for the user. 

Following that we dug into **usage statistics** which we can use to understand which parts of our system, or which users or agents are utilising the system the most. We can also monitor usage costs and compare usage costs across other potential providers by comparing historical usage metrics with published API pricing.

Then we looked at some of the generation settings available which can be used to tweak the LLM to provide more creative, or more deterministic outputs.

We also had a look at Chat Templates and how we can manually apply chat templates. This gives us a greater understanding of how models are fine-tuned for different prompting styles, and allows us flexibility in how we create generations from LLMs, especially if the server does not support a given chat template.

Finally we discussed System prompts, their purpose and what can be put into a good system prompt. I again encourage you to read some of the prompts included in Fabric for some great examples. We also briefly spoke about agents, and how system prompts can be used to define the different roles of an LLM in a larger system.

## Next Time…

In the next article we’ll deviate from LLMs and look at finishing our chatbot with a voice system, providing Text To Speech and Speech To Text functionality.

## Exercises for the reader

- Write a new system prompt for a workflow problem you think LLMs could solve
- Host the LLM on a second PC or laptop
- Connect to an Ollama server instead of llama.cpp
- Get an OpenAI key and connect to OpenAI instead of llama.cpp.
- Experiment with making detailed system prompts for a problem you have, or a task you have for LLMs.

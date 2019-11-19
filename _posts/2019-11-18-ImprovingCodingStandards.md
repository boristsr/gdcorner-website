---
layout: post
title:  "Improving Coding Standards and Quality"
date:   2019-11-18 11:17:13 +1100
tags: [development standards testing staticanalysis linting team]
comments: true
---

Coding Standards are often thought of as style guides, however coding standards should be more than merely a style guide. Beyond just style, I believe standards should encompass everything that is used to improve code quality and reliability. This includes how code is reviewed and what automated checks should be in place (before even discussing your testing strategy).

What goes into building a more complete set of coding standards? How can teams build a useful style guide? How can a good guide be used to improve team dynamics, rather than a tool to drown code reviews? How can tools be used to automate style checks? How can tools be used for more than just finding stylistic infractions?

<!--more-->

## Style Guide Basics

Coding Style Guides help keep code and APIs consistent. A good style guide should be made of recommendations for code that reduces the potential for errors and ensures consistent naming conventions. It should not be overly draconian in enforcing annoying trivial preferences.

### Follow the ecosystem

Language-wide style guides like [PEP8 for python](https://www.python.org/dev/peps/pep-0008/) are useful as even programmers new to the team will adapt quickly. Similar style guides exist for frameworks like [Angular](https://angular.io/guide/styleguide), [React (which actually uses airbnb’s style guide)](https://github.com/airbnb/javascript) and engines like [Unreal](https://docs.unrealengine.com/en-US/Programming/Development/CodingStandard/index.html) and [CryEngine](https://docs.cryengine.com/pages/viewpage.action?pageId=25530454). Think carefully before deviating from standards set by a language or vendor.

### Put it on a wiki

The coding standards should be listed somewhere super easy to find and reference, like the company wiki.

### Make it easy to link

The standards should have regular headings and sections that have individually linkable. The ensures specific content can be linked easily from anywhere such tickets, code reviews and IMs.

### Show examples

Add plenty of examples, both good and bad, as this can make it much easier for quickly checking something without having to read a whole section.

### Ensure it’s quick to skim

The document should be clear to read as a whole yet quick to glance at and search for reference. Examples help with this.

### Tabs vs Spaces, Brace placement, etc

Who cares? We aren’t living in the 80’s. Most IDEs automatically detect and match indenting, it’s not like you need to press space X times anymore. Tools can catch and fix mismatches. Flip a coin, pick one, configure your tools, and be consistent.

[As Bill Sourour says](https://www.freecodecamp.org/news/the-100-correct-coding-style-guide-5b594a1655f0/):
>Over the past 20+ years, I’ve followed every imaginable trend. I’ve followed the different conventions of different languages. None of it has impacted my bug count or made my code any more efficient.

There are also plenty of tools dedicated to auto-formatting code. Many of these come as plugins for IDEs that auto-format as you go or when you save. I highly recommend finding a few of these and providing pre-tuned configs for your developers. Takes all the hassle out of it.

### Look at other standards and style guides

Read other standards from open source or publically available projects. Examples such as the linux kernel, or the unreal engine standards have been built upon for over 20 years. There is wisdom to be found in these as they have been used, refined and have distilled lessons that involve working on multiple platforms, compilers and countless developers over many years. I’ve included some interesting ones below under [Further Reading](#further-reading).

### Discourage “clever”/complex syntax and tricks

If you read other guides and standards you would see a common thread is a recommendation to keep code super simple. The goal here is to reduce the time required to understand code and reduce the potential for errors.

In general the common recommendations are along the lines of:

* Avoid obscure syntax
* Avoid undefined behaviour
* Each line should do one thing, and one thing only
* Where complex statements are needed they should be adequately commented

### Purpose of rules

Any rules added should [not be based on preference](https://codeahoy.com/2016/05/22/effective-coding-standards/), rather they should have a specific goal in mind. Rules should either have the goal of reducing potential for errors or improving the maintainability and usability of the code.

As Joel Spolsky said in [Making Wrong Code Look Wrong](https://www.joelonsoftware.com/2005/05/11/making-wrong-code-look-wrong/):
> Let’s try to come up with a coding convention that will ensure that if you ever make this mistake, the code will just look wrong. If wrong code, at least, looks wrong, then it has a fighting chance of getting caught by someone working on that code or reviewing that code.

## Make the style guide a learning experience

### Explain the choices

Explaining the decisions behind style choices and providing examples can be good for seniors as well as people new to the discipline. An obvious benefit of this is it can help prevent too many subjective rules. Rules that are based more on personal preference, or at least appear that way, can frustrate other developers while providing no benefit to the team or codebase.

For newer developers providing examples and giving an explanation of the rules can help them to become a better programmer without having to learn the hard way why certain code can cause issues down the line. By explaining the pitfalls and showing one or 2 concrete examples it’s easier for newer developers to understand why.

I remember having a conversation with a friend who had recently entered the industry. They were asking why they were never allowed to use preprocessor definitions. All they ever heard was “don’t use gotos and don’t use preprocessor definitions” with no further elaboration. They didn’t have the experience behind them to see how preprocessor definitions can cause issues down the line, and rules repeated verbatim provided no intuition. Some examples and an explanation would have sped up the learning experience.

For more seasoned developers reading some of the reasoning behind choices can make it easier to adopt guidelines that they might otherwise find weird or frustrating, but it can also help them improve. There is always room for people to improve. After reading through the Unreal Engine 4 style guide and stumbling upon their [recommendation to always use braces in single statement if statements](https://docs.unrealengine.com/en-US/Programming/Development/CodingStandard/index.html#braces), I read their explanation of the reason and I actually adopted it into my own personal style too.

### Be Collaborative

Don’t isolate yourself and then deliver a document from on high. While the opinions of leads and architects should be influential, they aren’t perfect, and your whole team will have a lot of valid opinions and insights. Allowing the whole team a chance to make suggestions on new items and ask for clarification on others will help improve the guide. Hopefully this also gives a few extra chances for some cross-pollination of knowledge among members.

### Continuously Improve

Grow it overtime. Rules should be added when problems are repeatedly observed that may be improved with a new guideline.

## Handling multiple languages in style guides

It’s common to see a project that mixes at least 2 languages these days. There are a few ways to handle this. A good thought to keep in mind is the [advice in PEP8](https://www.python.org/dev/peps/pep-0008/#a-foolish-consistency-is-the-hobgoblin-of-little-minds):
> A style guide is about consistency. Consistency with this style guide is important. Consistency within a project is more important. Consistency within one module or function is the most important.

In general I try to respect the typical conventions of the language being worked in and then build consistency around the API exposed to other languages.

## Automated analysis

There are [many tools to help analyze code](https://realpython.com/python-code-quality/). Sometimes they are called linters or static analysis tools. Technically linters check style and static analysis tools check for bugs, however, many of the tools perform both. These are really useful and I recommend finding at least one for every language you work with.

Make sure to spend some time configuring each tool to match your standards and to fine tune the tool for your codebase. Many of these tools are very verbose by default. Make sure to suppress false positives and particularly noisy rules that are for trivial problems. The risk of not having a relatively clean output will be that it becomes habit for the team to ignore. This will be most important when first implementing analysis as ideally over time the list will be reduced to zero and then issues will be addressed as they crop up.

Some [recommend running multiple analysis tools](https://techbeacon.com/devops/how-google-facebook-do-code-analysis) on your codebase as each one will differ in the errors they catch. Each tool has their own strengths and weaknesses in finding problems, so running multiple can be a good way to increase effectiveness. This makes the previous paragraph much more important though. Running multiple tools compounds the problem of false positives & noisy trivial issues.

Some excellent insights into integrating static analysis tools into projects can be found on the [PVS-Studio blog where they often check open source projects](https://www.viva64.com/en/inspections/).

John Carmack wrote of [his experience reviewing new analysis tools for his project here](https://www.gamasutra.com/view/news/128836/InDepth_Static_Code_Analysis.php). One of John’s conclusions was:
>It is impossible to do a true control test in software development, but I feel the success that we have had with code analysis has been clear enough that I will say plainly **it is irresponsible to not use it**.

The PVS-Studio blog and John Carmack's article on his experience with static analysis are excellent with great insights. I highly recommend having a read through some of them.

Ideally you have an automatic process which performs both linting and analysis to report any potential errors that slip through to your main branches at check-in or regular intervals. Whether you have this process automated yet or not, the team should also be able to run these tools on demand or locally so they can check their code as they desire, especially before submission or merging.

Make sure your standard development environment includes a linter, an analysis tool and/or an auto-formatter. Don’t forget a tuned configuration to go with them!

## Enforcing the standards

Common advice you see is to [avoid being over the top with code style feedback in code reviews](https://www.mattlayman.com/blog/2017/no-nitpicking-code-reviews/), instead focusing more on design and potential bugs. I think this is sound advice. You want [code reviews to be focused on the bigger topics](https://medium.com/palantir/code-review-best-practices-19e02780015f). I find tooling helps with this. If more than 1 comment is based on style, summarising it all in a single comment like “I noticed a few stylistic issues, don’t forget to run the linter before merging” can be better than drowning the review in trivial comments. This saves time for the reviewer and won’t frustrate or demoralize the developer who is submitting code for review.

If you are implementing or revising standards on an existing codebase do not expect or aim to conform the codebase quickly. This will only slow development without providing a worthwhile return. Instead, let developers fix issues as they touch old code or attack it as filler tasks over time.

I’d recommend performing regular automated reviews of the entire codebase. Ideally though you have automated checks running after every commit. This can publish the report so it is accessible by the whole team with a top line summary that shows the total number of issues and the difference to the last build sent to slack or wherever you gather team notices).

Many automated analysis errors turn out to be relatively trivial fixes (not checking bounds, forgetting to free memory, style fixes, etc) but it can be time consuming to get an existing code base to confirm to new or recently revised standard. Having up to date reports can be used as good filler tasks for a dev when they need a break from their current task but still want to be productive.

A quick team review of the report at every sprint retro can show whether progress is being made or whether too many issues are slipping through

## Conclusion

Hopefully I’ve shared some tips which you can take and improve your own standards and processes. I haven’t covered code reviews or wider testing strategies as these are in-depth topics on their own, although many of the articles I've linked to have at least partially cover these topics.

What do the standards at your company look like? Do you disagree with anything here? Have you got further tips for improvement? I’d love to hear them. Feel free to share your thoughts.

## Further Reading

[Unreal Engine 4 Coding Standard](https://docs.unrealengine.com/en-US/Programming/Development/CodingStandard/index.html)

[PEP8 document outlining python standards](https://www.python.org/dev/peps/pep-0008/)

[Linux Kernel Style Guide](https://www.kernel.org/doc/html/v4.10/process/coding-style.html)

[ISO CPP Code Guidelines](https://github.com/isocpp/CppCoreGuidelines/blob/master/CppCoreGuidelines.md)

[ISO CPP FAQ](https://isocpp.org/wiki/faq/coding-standards)

[MyPy Static Type Checker](http://mypy-lang.org/)

[PyLint linter & error analysis](https://www.pylint.org/)

[Static Analysis included within Visual Studio](https://blogs.msdn.microsoft.com/hkamel/2013/10/24/visual-studio-2013-static-code-analysis-in-depth-what-when-and-how/)

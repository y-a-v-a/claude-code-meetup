## Narrative

### The laugh

In March 2025, just a week or two after Claude code was released as research preview, our family was sitting at weekend breakfast and i was looking at my laptop on and off, and at some point i started laughing. 
My wife asked me: what are you laughing about? What are you watching on YouTube?
And though it indeed looked like i was watching a video, i was watching the output of Claude code. And i had to laugh. It was a rich laugh, bittersweet with a little anxiousness, a laugh i seem to laugh when looking at good comedy too. Hance my wife's remark, i suppose. 
In that laugh i realized that what i saw happening on my laptop screen would drastically change IT, and i had the intuition that these changes would not be limited to IT only. 
(I was playing around with building Trumplang, an esoteric programming language, images in `assets/Trumplang2.png`)
After fiddling and playing around with chatgpt and Claude chat for a few weeks, i had picked up a bigger project i wanted to work on with ai, to see how it would work out. 
And it was probably in that laugh that i also realized i started understanding how i had to interact with this new tool called Claude code. 
What i was building, and how, I'll tell you later but first: how did i get from my first prompt to this stage?

### Before Claude Code

Looking back at the weeks before i started using Claude code, i was playing around with simple prompts.

- I had been experimenting a few weeks with Aider https://aider.chat/ which I found pretty hard.
  - there was a ton of configuration which cost me too much time to understand
  - but it was my first touch with ai coding agents
  - i had it built some small webpages

### Claude Code research preview

- I started using Claude Code right after its first release at the end of February 2025.
- At the time it was called "research preview" and basically had no limits.

### Find an isolated problem and fix it with ai

My son once asked: what would happen when i stick a nail straight through earth, where will i end up? I thought that would be a nice small ai coding challenge which worked out pretty well. (antipode map webapp, https://vibes.vincentbruijn.nl/antipode/ ) Image: `assets/antipode.png`

I think my "drivers" to pick up and learn easily are my ideas: I tend to have a lot of ideas for apps, sites, computer programs, etc. 

### Scaling up: adapt your thinking while you are doing

There are several challenges that I had to cope with along the way
- parallelization
  - I was running 10 projects in parallel at some point.
  - this was exhausting
- trust issue: when do you accept or do you feel confident enough to let the AI coding tool just do its work?
  - yes, that's what CTO's must feel like too! You need to learn some of their skills
- SDLC
  - lack of overview because it delivers so much so quickly
    - solution: html support files
  - ask for detailed ticket descriptions by your business analyst
    - could be made with AI, as long as the business process or value is expressed as a clear goal.

### Show

- Twain the markdown reader
  - I noticed the AI models like MarkDown very much, but it is hard to read them un-formatted.
    - assets/Markdown-plain.png
    - assets/Markdown-rendered.png
- Quicklook plugins
  - assets/Quicklook.png

### What failed

- I haven't fixed my inbox yet
- I haven't built clear team dashboards yet

### Bridge to skills

- I wanted to learn from how I do prompting, but it was hard to get insights in old sessions
  - so I built a session export skill
- That is a skill. So what is a skill?
- `file:///Users/nlbruiv/Projects/vincent/session-exports-html/claude-session-2026-07-05T10-51-35-496Z_7ffb337d-4114-4bf9-abe0-8f19a44af603.html` is a file that can be opened to show a session export
  - and an image is in `assets/session-export.png`


## Skills deepdive

- AI agent extensions
- Skills are basically an disitilled set of capability, a group of operations
- Skills are discovered progressively
  - so "little by little"
  - initially only a description of what the skill can do or what it is used for
  - when the agent is triggered by a user message on the skill's description, or when called explicitly with a slash-command, then the agent will start to discover the skill further and take actions where needed.
- benefits
  - reduce retyping of instructions
    - reduction of repetitive work
  - operate on isolated topics
  - can be enriched with scripting/coding capabilities
  - can operate on office software file types too

### Examples

  - "attribution"
    - add "Vincent Bruijn, (c) YYYY" to a specific code file
  - "grill me"
    - a classic skill which questions the user relentlessly on the initial prompt's problem-scope.
    - used a lot by coders, but can also be used for other kind of vague-to-concrete ideation
  - session export
    - my own skill to make an HTML export of a Claude session, which is basically a shareable asset
    - why? I wanted to learn from my own sessions, but how to look back coding sessions? this appeared to be hard, so I made my own export.
  - "mand" skill
    - make the response shorter
    - a bit of a gimmick, but does work!
    - inspired by Maxim Hartman's video with 
    - https://www.youtube.com/watch?v=ypSKDY4Jp3g

### Example detail

*Mand* skill, inspired by Maxim Hartman's video with Ben Strik (mention both names).
Image: `assets/Mand.png`

> I want to make a "mand" skill, which makes your output shorter, a summary of your initial response, inspiried by the Maxim Hartman clip of him interviewing a guy selling a nice china bowl asking the man to respond with a shorter answer. Can you guide me build that skill for you?

> Maybe extend it with an Enligh counterpart "shorter"

> OK let's warp it up into a downloadable markdown file.

Huh? Why this way? The Claude desktop app also has a skill-builder skill!


## Key takeaways

- how you have to adapt your thinking while you are doing.
  - What I mean by that is that the AI coding tool is so powerful, that you have to change your thinking about how you build software while you are learning how this new tool works.

- find a problem, build an AI-based solution
  - Peter Steinberger (OpenClaw)
    - https://gogcli.sh/
      - He wanted proper Google tooling access, he builds it
  - my own: the session export skill

- start small and isolated, then let trust grow
  - distill anything you repeat into a skill

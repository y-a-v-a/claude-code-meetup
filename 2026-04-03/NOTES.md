# meetup Amsterdam 

Friday April 3rd, 2026

Vincent Bruijn
supported by Anthropic

- skills
  - progressive disclosure
    - don't make your SKILL.md files longer than 50 to 70 lines
      - it's the only file that is intially read
        - it should describe the core capabilities and use
      - expose more context with markdown links, Claude can trace them
      - add a scripts directory for further functionality
      - one can call this "skill engineering"
      - The internal Claude Dekstop app skills are between 200-400 lines
  - example
    - Google Programmable Search Engine
      - create a scoped vulnerability source
        - steerable for your purposes
        - accessible via API key
        - use the skill while coding
    - web-to-markdown skill
      - puppeteer-core and turndown
        - headless browser
          - fetch a website, wait for it to be fully loaded (also supports SPA pages)
          - grab HTML, stuff it into turndown
        - return markdown
    - Combined they are a strong combo
- agents
  - specialist subprocesses for your running session
    - project based, or user based
    - can be designed on the fly
    - can be predefined manually
    - no polution of main context
      - agent can return only relevant data
    - can assign a color
  - example
    - vulnerability agent
      - combine both earlier mentioned skills
- openclaw alternative
  - new feature of Claude Code called "channels"
    - so far supports iMessage, Discord and telegram
      - https://github.com/anthropics/claude-plugins-official/tree/main/external_plugins/telegram
    - keep a claude code process running and message to it
    - can be very powerful in combination with
      - MCPs
    - gets close to OpenClaw
      - biggest difference
        - OpenClaw has a gateway as "manager" for channels and messages
        - Claude Code channels are sequential
  - example
    - combine 
      - overwriting system prompt of claude code
      - channels
      - dedicated .claude directory
    - this way you get
      - isolation
      - general purpose
      - remotely accessible
      - start in background
    - basically an OpenClaw clone
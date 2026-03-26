Claude Code strategies

- convo style
  - start with an idea, express it to Claude
    - you can start with plan mode for initial idea expression and continue with an extended back-and-forth
    - going quickly from plan mode to implementation mode
  - start with an idea, ask Claude to grill you about it
    - best to do this in planning mode
  - start with an idea in a simple PLAN.md file
    - ask claude to read the plan file, and let it write progress into the PLAN.md file
    - decide whether you want to
      - translate it into a tasks list in a file
      - let the plan be implemented
      - make an explicit tasks list in length
    - have it write PRDs per problem domain
      - start new Claude session to have the PRDs implemented one-by-one
      - don't overdo the PRDs
        - don't make them too long, no more than 100-150 lines
        - make them domain / topic specific
  - sub-agent style
    - define ~2 subagents both with supportive tasks
      - code review
      - plan review
      - tech specific (web specialist, python specialist, etc)

- hands-on style
  - webapp with webaudio
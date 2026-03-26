# Workshop: Build a TUI Sound Tool with Claude Code

## Strategy: Plan-Then-Execute (The Ralph Loop)

This exercise teaches the **task-list workflow** — you do all the thinking upfront, write a plan, break it into discrete tasks, then let Claude execute them autonomously. Instead of a conversation, you're an architect handing off a spec to a builder.

### Why this works

- Forces you to think before you code
- Each task is small, testable, and independent
- Claude can execute without you steering every step
- You can walk away and come back to a working (or partially working) tool
- Mirrors how you'd work with an autonomous agent in production

### The workflow

```
You think → PLAN.md → Claude generates → TASKS.md → Claude executes → Working code
```

1. **You** write a `PLAN.md` describing what you want to build
2. **Claude** converts it into a `TASKS.md` with numbered, atomic tasks
3. **Claude** executes tasks one by one, either:
   - **YOLO mode**: `claude --dangerously-skip-permissions` (runs once with no permission prompts)
   - **Ralph loop**: `while :; do cat PROMPT.md | claude --dangerously-skip-permissions; done` (picks up one task per iteration, loops until done)

### Key concept: one task per loop

The Ralph loop (named after [Ralph Wiggum](https://ghuntley.com/ralph/)) runs Claude in a bash loop. Each iteration, Claude reads the task list, picks the next uncompleted task, implements it, tests it, marks it done, and exits. The loop restarts Claude with a fresh context window for the next task.

This prevents context window bloat and keeps each task focused.

### Key concept: backpressure

Autonomous Claude needs guardrails. Without them, it'll generate code that compiles but doesn't work. Backpressure = automated checks that catch bad output:

- **Type checking** — catches structural errors immediately
- **Tests** — each task should include a verification step
- **Compilation** — if using a compiled language, this is free backpressure

Your PROMPT.md should instruct Claude to run these checks after each task.

---

## Setup

Create a new directory for your project:

```bash
mkdir tui-synth && cd tui-synth
```

---

## Phase 1: Write your PLAN.md

Open your editor and create `PLAN.md`. This is YOUR document — Claude doesn't write it, you do. Describe what you want to build in plain language.

Here's an example to get you started (but write your own!):

```markdown
# TUI Sound Tool

A terminal-based drum machine / tone sequencer that runs in the terminal.

## What it does
- Displays a step sequencer grid in the terminal (8 or 16 steps)
- Each row represents a different sound (kick, snare, hi-hat, tone)
- User navigates the grid with arrow keys and toggles steps with spacebar
- Pressing Enter/Play starts playback — it loops through the steps and plays the active sounds
- Tempo is adjustable

## Sound generation
- Sounds are generated programmatically (not samples) — use sine waves, noise, or synthesis
- Audio output goes to the system speakers

## Tech preferences
- Language: [Python/Go/Node/Rust — pick what you know]
- TUI framework: [textual/bubbletea/blessed/ratatui — or let Claude decide]
- Audio: [whatever works on my OS]

## Non-goals
- No MIDI support needed
- No file export
- Doesn't need to look beautiful, just functional
```

**Spend 5-10 minutes on this.** The better your plan, the better the output.

---

## Phase 2: Generate TASKS.md

Now start a Claude Code session and ask it to create the task list:

```bash
claude
```

**Prompt:**

> Read @PLAN.md and create a TASKS.md file. Break the plan into numbered, atomic tasks. Each task should be implementable in isolation and testable. Order them so each task builds on the previous one. Start with project setup and end with the full working tool. Format each task as a checkbox: `- [ ] Task description`.

**Review the TASKS.md Claude generates.** This is your last chance to adjust before autonomous execution. Check:

- Are the tasks ordered correctly? (dependencies flow top-to-bottom)
- Is each task small enough? (if a task says "implement the sequencer grid with playback and sound", that's too big — split it)
- Is there a task for setting up the project and installing dependencies?
- Does the last task involve running the full tool end-to-end?

Edit the TASKS.md yourself if needed. Then exit the Claude session (`/exit`).

---

## Phase 3: Write your PROMPT.md

This is the instruction file that Claude reads at the start of each loop iteration. Create `PROMPT.md`:

```markdown
You are working on a TUI sound tool project. Your instructions:

1. Read TASKS.md and find the first unchecked task (marked `- [ ]`)
2. Implement ONLY that one task — do not skip ahead
3. After implementing, verify your work:
   - Run the linter/type checker if applicable
   - Run any tests
   - Make sure the project still builds/runs
4. If the task works, mark it as done in TASKS.md: change `- [ ]` to `- [x]`
5. Git commit your changes with a descriptive message
6. Stop. Do not continue to the next task.

Important:
- Read existing code before writing new code
- Do not rewrite files that already work
- If a task is unclear, implement your best interpretation and note it in a comment
```

---

## Phase 4: Let it rip

You have two options:

### Option A: YOLO mode (simpler)

Run Claude once with all permissions, pointing at the task list:

```bash
claude --dangerously-skip-permissions "Read PROMPT.md and execute the instructions"
```

Claude will work through tasks until it runs out of context or finishes. If it stops partway, run the same command again — it'll pick up where it left off thanks to the checkboxes in TASKS.md.

### Option B: Ralph loop (more robust)

```bash
while :; do cat PROMPT.md | claude --dangerously-skip-permissions; done
```

This restarts Claude for each task with a fresh context window. Press `Ctrl+C` when all tasks are checked off (or when you want to stop).

### Watch it work

While Claude runs, you can:
- Watch the git log grow: `watch git log --oneline -20`
- Check progress: `cat TASKS.md`
- Test the tool whenever a batch of tasks completes

---

## Phase 5: Review and adjust

Once Claude finishes (or you stop it), check the result:

```bash
# See what was built
cat TASKS.md

# Try running the tool
# (depends on your language/framework — check the project for run instructions)
```

Things might not be perfect. That's expected. You can:

1. Add new tasks to TASKS.md and re-run the loop
2. Switch to **conversational mode** for fine-tuning: `claude` → tell it what to fix
3. Fix things manually — it's your code now

---

## Reflection

After building, think about the planning workflow:

- Was your PLAN.md specific enough? Where did Claude have to guess?
- Were the generated tasks the right granularity?
- How did the autonomous result compare to what you imagined?
- Where would more backpressure (tests, type checks) have helped?
- When would you use this strategy vs. the conversational one?

The task-list strategy works best when you **know what you want** and can describe it clearly upfront. It trades real-time control for speed and hands-off execution. The quality of your plan directly determines the quality of the output.

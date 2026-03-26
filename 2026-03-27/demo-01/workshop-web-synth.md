# Workshop: Build a Web Synth with Claude Code

## Strategy: Conversational Iteration

This exercise teaches the **conversational workflow** — the most natural way to use Claude Code. You have a dialogue: you ask Claude to build something, you review what it made, you give feedback, Claude adjusts. Rinse and repeat.

### Why this works

- You stay in control at every step
- You can change direction based on what you hear
- You learn what kinds of prompts get good results vs. vague ones
- It mirrors how you'd pair-program with a human

### Tips for effective conversation

| Do | Don't |
|---|---|
| Be specific about what you want changed | Say "make it better" |
| Describe the *behavior* you want | Prescribe the exact code |
| Give feedback on what you see/hear | Stay silent and re-prompt from scratch |
| Ask Claude to explain choices you don't understand | Accept code you can't follow |
| Course-correct early ("not that, I meant...") | Let it go 3 steps in the wrong direction |

### When to be vague vs. specific

- **Be vague** when you want Claude to make design decisions: *"Add some way to control the sound"*
- **Be specific** when you know what you want: *"Add a lowpass filter with a cutoff knob ranging from 20Hz to 20kHz"*
- **Start vague, refine specific** is the best pattern for learning

---

## Setup

Create a new directory for your project:

```bash
mkdir web-synth && cd web-synth
```

Start a Claude Code session:

```bash
claude
```

You'll do everything from within this session.

---

## Step 1: A sound from nothing

**Ask Claude something like:**

> Build me a simple web page with a single oscillator using the WebAudio API. I want to click a button and hear a tone. Use plain HTML/JS, no frameworks. Keep it minimal.

**What you should have now:**
- An `index.html` file (maybe with inline JS, maybe a separate `.js` file)
- A button that plays a tone when clicked
- A way to stop the tone

**Open it in your browser:**
```bash
open index.html
```

**Try it.** Does it work? Does it sound right? Does the button behave as expected?

**Conversation move:** Tell Claude what you think. For example:
- *"Works, but the tone just cuts off abruptly when I stop. Can you add a short fade-out?"*
- *"I want to hear a sawtooth wave instead of a sine wave"*
- *"The button doesn't indicate whether sound is playing or not"*

---

## Step 2: Play it like an instrument

Right now you have one button, one tone. That's not an instrument.

**Ask Claude something like:**

> I want to play different notes using my computer keyboard. Map a row of keys (like A, S, D, F, G, H, J, K) to a musical scale so I can play melodies.

**What you should have now:**
- Keyboard input handling
- Different frequencies mapped to different keys
- The ability to play melodies by pressing keys

**Try playing something.** Does it feel responsive? Are the note frequencies correct? Can you play multiple notes?

**Conversation move:** Give feedback on how it *feels*:
- *"There's a click/pop when notes start — can you add a short attack?"*
- *"I want to be able to hold a key and have the note sustain"*
- *"Can you show which key is being pressed on screen?"*

---

## Step 3: Shape the sound

One oscillator with one waveform gets boring fast. Let's add character.

**Ask Claude something like:**

> Add a second oscillator. I want to be able to choose the waveform for each (sine, square, sawtooth, triangle) and detune the second oscillator slightly to make a fatter sound.

**What you should have now:**
- Two oscillators per voice
- Waveform selectors (dropdowns or buttons)
- A detune control for the second oscillator

**Try it.** Stack a sawtooth and a slightly detuned sawtooth — that's the classic analog synth sound.

**Conversation move:**
- *"Add a mix knob so I can blend between the two oscillators"*
- *"The UI is getting cluttered — can you organize it into sections?"*
- *"I want a visual indicator showing the current waveform"*

---

## Step 4: Filter it

Every synth needs a filter. This is where things start sounding real.

**Ask Claude something like:**

> Add a lowpass filter to the signal chain. Give me a cutoff frequency knob and a resonance knob. The cutoff should feel smooth when I drag it.

**What you should have now:**
- A filter in the audio signal chain
- Cutoff frequency control (ideally logarithmic — 20Hz to 20kHz)
- Resonance/Q control
- Optional: filter type selector (lowpass, highpass, bandpass)

**Try sweeping the cutoff while playing notes.** This is where the fun starts.

**Conversation move:**
- *"The cutoff knob doesn't feel right — low values should change the sound more dramatically"* (hint: logarithmic scaling)
- *"Can I switch between filter types?"*
- *"Add a simple ADSR envelope for the filter"*

---

## Step 5 (Stretch): Add some space

If you have time, add an effect.

**Ask Claude something like:**

> Add a delay effect with controls for delay time, feedback amount, and wet/dry mix.

Or go for reverb, distortion, or an LFO modulating the filter cutoff — whatever sounds interesting to you.

**This is your instrument now.** Make it sound the way you want.

---

## Reflection

After building, think about the conversation you had with Claude:

- Which prompts got you the best results?
- When did being vague help vs. hurt?
- How did your feedback change what Claude built?
- What would you do differently if you started over?

The conversational strategy works best when you **treat Claude like a collaborator, not a vending machine.** The more context and feedback you give, the better the output.

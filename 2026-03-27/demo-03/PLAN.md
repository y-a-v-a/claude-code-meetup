# 4-Track Looper — Spec

Build a web-based 4-track audio looper using the Web Audio API and MediaRecorder API. No dependencies. Single HTML file. Chrome only.

## Behaviour

- 4 independent looper tracks rendered as rows
- Each track: hold REC button to record audio from the microphone, release to stop
- Maximum recording length is 10 seconds; recording auto-stops if the user holds longer
- After release, the recorded audio immediately starts looping on that track
- Loops run independently — no sync to a master clock or other tracks
- Each track can be re-recorded at any time (overwrites previous recording)
- Each track has a mute/unmute toggle; muted tracks silence with a short gain fade
- One recording per track — no overdub

## UI

- Minimal dark UI, monospace font
- Per track: track number, REC button (circular), waveform display, MUTE button, status LED
- Waveform is drawn from the decoded AudioBuffer after recording completes
- LED states: off = empty, green = playing, red blinking = recording

## Technical constraints

- Vanilla JS, no build step, no frameworks, no external assets
- Single `index.html` file
- Use `AudioBufferSourceNode` with `loop: true` for playback
- Lazy-init `AudioContext` on first user interaction to satisfy Chrome autoplay policy
- Canvas pixel dimensions must account for `devicePixelRatio` for sharp rendering on retina screens
- Microphone stream must be stopped after recording ends (no open tracks)

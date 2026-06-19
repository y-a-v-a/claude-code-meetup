# Claude Meetup Amsterdam 4th edition

- Welcome to 4th edition of Claude Community Meetup Amsterdam
- There's a World Cup, it's great wheather, but glad to have you here.
- After each talk we have room for a few questions

---

- Future
  - End of August small meetup
  - Beginning September Eindhoven
  - End of September Amsterdam, different location



## Speaker notes

- Open cold
  - No title, no name. Show the piece
  - Hit reload two or three times so it changes
  - Stay silent a beat. Let the room get curious. (~60–90s)
  - If the network is shaky, present the real site in a browser instead of this iframe.
- The hook
  - Nobody created that image — no designer, no prompt I typed just now.
  - Then turn to how it got there.
- The reveal.
  - Name the project. One sentence on what it is.
  - Don't list the stack yet — that comes through the loops.
- The DNA is the single source of artistic truth.
  - The generator reads it to make; the jury reads it to judge.
  - The system encodes no taste of its own.
- Division of labour is a design choice: the maker and the critic are different vendors so nothing flatters itself.
  - The human is the third party.
- THE beat. The agent runs unattended on a Mac mini; when something clears the gate it emails me; I review it from my phone over Tailscale and tap.
  - Human-in-the-loop made physical.
- The intellectual spine for a builder audience:
  - agents get good when you put them in a structured loop with checks and a human checkpoint; not when you find the perfect prompt. Set up the two-loops section.
- Walk it once, left to right. The only human box is "I approve" — and it's the only bold one.
  - Generation is ~$0.40; judging is half a cent; it runs every 3 hours whether I'm watching or not.
- Same shape, different stakes.
  - The bold box is a skill — a written playbook the agent runs to validate the app after a change.
  - Tiered by cost: free checks always, the paid ones only when relevant.
- This is the part builders lean in for: the verification skill isn't static.
  - When it hits a wall, the instruction is to solve it AND amend the skill — so next time is smoother. The loop learns.
- Put them side by side conceptually.
  - The symmetry is the takeaway: structure + a checkpoint.
  - In one, the checkpoint is human judgement; in the other, a self-revising procedure.
- The pivot from "how" to "why".
  - Everything so far was mechanism; now the mechanism turns out to be the subject.
- Demo it live if you can: click acquire → it downloads a copy of its own source.
  - The machine made a work whose subject is exactly the thing it is: a copy with no original.
- The thesis, stated plainly.
  - It's not a tool that makes images
  - it's an artist that doesn't know whether it's an artist
  - and keeps producing evidence either way.
- A light beat near the end.
  - The cost asymmetry is funny and on-brand for a project about value and "but is it art?".
  - Cut this slide first if you're over time.
- Land on the live URL — invite them to watch the catalogue grow. Restate the one-liner. Thank you.

## Key takeaways

- **Trust your checkpoints, not the model.** Loops aren't new; the SDLC always had them. What's new is how many steps you dare pull *out* of the loop — and every step you remove is a step you've decided to trust the model with. I shipped code I never read. That's not "the model takes responsibility" — it's that I moved my trust from reading diffs to a loop that checks itself: 84 tests and a `/verify` skill that rewrites itself. The question was never "do you trust the model?" It's "do you trust your checkpoints?"
- **The pieces aren't new — the arrangement is.** Vercel, Tailscale, email, GitHub, Claude — none of it is new, and none of it is the point. The non-obvious move isn't wiring SaaS together; it's deciding *where a human still belongs* — one tap on my phone — and making the critic a different vendor so nothing grades its own work. Knowing where to keep a human is the design.
- **Closer (say it, don't list it):** …and the whole thing is a machine asking, every three hours: *but is it art?*
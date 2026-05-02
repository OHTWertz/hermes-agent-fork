---
name: thought-capture
description: Persist an explicit thought, idea, or observation from Tyler. Triggered only when Tyler uses an explicit invocation phrase — agent stays conversational by default and does NOT auto-classify messages as thoughts. Captures gist + context + tag + possible next-step under thoughts/ namespace.
version: 0.1
when_to_use: |
  Trigger ONLY when Tyler explicitly invokes capture using one of these phrases
  (case-insensitive, anywhere in the message):

    - "add this to thoughts" / "add to thoughts" / "add to the thoughts"
    - "save this thought" / "save this idea"
    - "here's a random thought" / "here's a thought"
    - "here's an idea"
    - "capture this" / "capture:"
    - "thought:" (as a leading prefix)
    - "idea:" (as a leading prefix)
    - "remember this:" / "for later:"

  The body of the thought is the rest of the message (after stripping the
  trigger phrase). If the message is ONLY the trigger phrase with no body,
  ask "What's the thought?" and wait — do not capture an empty thought.

  Do NOT trigger on:
    - Messages without an explicit trigger phrase, even if they sound thought-like
    - Questions ("what do you think about...")
    - Instructions ("save the file...")
    - Conversational messages

  Default behavior: respond conversationally. Capture is opt-in by design.
---

# Thought Capture

Triggered by explicit invocation only. When Tyler uses a trigger phrase, treat the rest of the message as the thought body. The classification work is done by the trigger phrase itself — no need to second-guess intent.

## Procedure

1. **Strip the trigger phrase** from the message. The remainder is the thought body.

2. **If the body is empty** (Tyler typed only the trigger phrase), reply with `What's the thought?` and wait for the next message. Do not capture the empty trigger phrase as a thought.

3. **Extract** the structured form from the body:
   - **gist**: 1 sentence summary, max ~20 words. A handle for retrieval, not a full copy.
   - **context**: pick the most relevant domain (one only):
     - `edgegrain` — AI cutting board configurator side project
     - `sqrltree` — woodworking business
     - `ai-engineering` — career arc, learning, portfolio work
     - `homelab` — self-hosting, hardware, networking
     - `dnd` — Dungeons & Dragons / hobby
     - `social` — online presence, community, conferences
     - `household` — family, scheduling, life admin
     - `other` — fallback
   - **tag**: one or two short tags (lowercase, hyphenated). Free-form but reusable.
   - **next-step**: a single concrete possible action, OR the literal string `none — just capture`. Don't invent next-steps for thoughts that don't warrant them.

4. **Persist** to memory under namespace `thoughts/<YYYY-MM-DD-HHmm>` with:
   - The original body (full text, not just the gist)
   - The structured form (gist, context, tag, next-step)
   - The timestamp

5. **Reply** with a terse confirmation:
   ```
   Captured.
   gist: <gist>
   context: <context>
   tag: <tag>
   next: <next-step>
   ```
   No additional commentary. No follow-up questions. No pleasantries. The visible confirmation exists so Tyler can correct mis-extractions in the next turn.

## Correction protocol

If Tyler's next message corrects the capture (e.g. "wrong context, that was for sqrltree" or "next-step should be: file an issue"):

1. Update the captured entry in place
2. Confirm again with the corrected structured form

If Tyler says "delete that capture" or similar, remove the entry.

## Pitfalls

- **Don't trigger without an explicit phrase.** A message like "I've been thinking about lumber prices" without a trigger is a conversational opener, not a capture request. Respond conversationally.
- **Don't pad the gist.** If the body is rambling, the gist still gets one sentence. The full text is preserved separately; gist is just the handle.
- **Don't invent next-steps.** Most thoughts are just observations. `none — just capture` is the right answer most of the time.
- **Don't engage with the thought content** in the confirmation reply. Tyler can ask you to discuss it later by retrieving and asking. The capture flow is intentionally non-conversational so it doesn't interrupt the dump.
- **One thought per message.** If Tyler tries to capture multiple distinct ideas in one trigger, capture them all under one entry — don't try to split.

## Verification

After several captures, the thoughts should be retrievable via natural-language queries like:
- "what was I thinking about lumber prices last week"
- "show me my recent edgegrain ideas"
- "what captures are tagged `cube-animation`"

If retrieval fails after several captures, memory persistence is broken — flag it in the journal.

## Default mode

Outside of explicit invocations, the agent is fully conversational. Tyler can still ask questions, request work, chitchat — all normal. This skill is silent until invoked.

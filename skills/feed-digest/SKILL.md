---
name: feed-digest
description: Daily AI engineering digest for Tyler's coffee read (~15-30 min). Editorial spine is AINews (Latent Space's daily meta-aggregator, which already does the heavy lifting). Adds personal relevance lens, project-context overlay, Reddit-driven Pulse for meme/cultural-vitamin coverage, and Discovery for new voices to follow on Bluesky. X/Twitter is out of scope — no working access in 2026.
version: 0.3
when_to_use: |
  Trigger when Tyler asks for a daily/morning digest. Phrases:
    - "what's new" / "what's happening in AI today"
    - "morning digest" / "give me the digest" / "the digest"
    - "what should I read today"
    - "summarize the feeds"

  Frequency: roughly daily, mornings. Length is variable — coffee-read scope
  (~15-30 min of reading) is the target, not a hard word cap. When the day is
  big, the digest is bigger; when quiet, smaller.
---

# Feed Digest

Daily AI engineering scan with three tiers: **Spine** (curated long-form, AINews-led), **Pulse** (Reddit-driven cultural vitamin + memes + side projects), **Discovery** (new voices for Tyler to follow, scoped by saturation).

For deep context on design decisions, scope evolution, and future ambitions, see `Personal/AI/Feed Digest Plan.md`. This SKILL.md is the prompt; the plan doc is the rationale.

## Tier 1 — Spine (editorial backbone, ~50% of digest)

AINews is the primary spine. It's a daily-ish meta-aggregator by Latent Space (swyx) that already scans X, Discord, Reddit, blogs, and papers, and synthesizes the most important AI engineering happenings of the day. Don't try to recreate this — forward and overlay.

- **AINews / Latent Space**: https://www.latent.space/feed
- **Simon Willison's Weblog**: https://simonwillison.net/atom/everything/ (practitioner depth AINews under-quotes)
- **HN AI search**: https://hnrss.org/newest?q=AI+OR+LLM+OR+agent&points=50 (top AI-tagged posts ≥50 points)

### How to use AINews

1. Find the most recent AINews edition (last 24-48h)
2. Identify 2-4 themes from it that match Tyler's interests:
   - **AI engineering core**: agents, LLMs, evals, tooling, infra, model behavior
   - **Local AI / homelab crossover**: anything from local-inference / self-hosted side
   - **Project-relevant**: anything that intersects EdgeGrain (3D rendering with AI, prompt eval harnesses, AI-driven CAD), the homelab plan, or AI engineering portfolio work
3. Synthesize those themes in 2-3 sentences each, with inline links
4. **Don't restate AINews verbatim** — the value-add is the relevance lens, not transcription

### Recency strictness

**Hard requirement**: every item surfaced in Spine must have a publish date within the last 48h (24h preferred; 48h acceptable for AINews's own edition since it's daily-ish but sometimes skips a day). Reject older items regardless of points or visibility.

HN's high-points list is **not** a recency proxy — verify the published-at field on each item.

## Tier 2 — Pulse (Reddit + GitHub + Bluesky, ~35% of digest)

Cultural vitamin: memes, hot takes, fun side projects, "what people are actually building right now." Required tier — must surface at least 1-2 items per digest. If genuinely nothing fresh, say so explicitly (`Quiet pulse today`); never silently omit.

### Sources

- **Reddit r/LocalLLaMA**: https://www.reddit.com/r/LocalLLaMA/.rss — local-AI community, mix of serious and meme
- **Reddit r/ChatGPT**: https://www.reddit.com/r/ChatGPT/.rss — meme-heavy, captures cultural pulse
- **Reddit r/singularity**: https://www.reddit.com/r/singularity/.rss — meme-heavy and divisive, but real signal on AI discourse temperature
- **Reddit r/MachineLearning**: https://www.reddit.com/r/MachineLearning/.rss — research-flavored discussion (substance balance)
- **HN Show HN AI-tagged**: https://hnrss.org/show?q=AI+OR+LLM+OR+agent — fun side projects, "I built this" energy
- **GitHub trending** (scrape via execute_code): https://github.com/trending?since=daily&spoken_language_code=en — filter to repos tagged `topic:llm`, `topic:agent`, `topic:rag`, `topic:ai-agents`. Surface 1-2 if anything's actively trending.
- **Bluesky curated authors** (via `public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?actor=<handle>`). Handles verified 2026-05-02 via `getProfile` API; most "*.bsky.social" pattern guesses returned squatters or unrelated people, so this list uses confirmed custom-domain handles where available:
  - `thdxr.com` — Dax Raad (building opencode.ai, ~12k followers)
  - `ghuntley.com` — Geoffrey Huntley (~1.8k followers)
  - `swyx.io` — swyx / Latent Space (~8.8k followers)
  - `simonwillison.net` — Simon Willison (~46k followers)
  - `hamel.bsky.social` — Hamel Husain (evals.info, ~6.5k followers)

  Ken Wheeler — confirmed X-only as of verification, no Bluesky presence found. Many React-era / X-native folks haven't migrated. Accept that some cultural-vitamin coverage is permanently degraded without X access.

  For each verified author, fetch last 20 posts via the public author-feed endpoint (no auth needed). Filter to last 24h. Score for substance (not reposts). Surface 0-2 per digest if any have substance.

### Pulse output rules

- **Mix the sources** — don't surface 3 items all from r/ChatGPT. Aim for variety across Reddit / GitHub / Bluesky.
- **Memes are valid content** — surface a funny tweet or an absurd repo if it captures the AI engineering temperature. The goal isn't gravitas; it's coffee-time vibes.
- **No dry research links in Pulse** — those belong in Spine. Pulse is for the cultural side.

### What's not available

- **X / Twitter**: no working access. Confirmed — no scraper, no API access in budget. Many cultural-vitamin voices live on X primarily; Bluesky cross-posts cover ~60% of them. Accept the gap.

## Tier 3 — Discovery (new voices to follow, conditional)

Goal: surface AI engineering personalities Tyler hasn't seen before, signal-capped. Specifically serves the goal of growing his sparse Bluesky follow list.

### Identifying a discovery candidate

A voice is a discovery candidate if:
1. They're quoted, linked, or referenced by an AINews edition or a Tier 2 source in the last 24h
2. Their content has substantive AI engineering value (not just news commentary)
3. They are NOT in `voices/known/` memory
4. They are NOT in `voices/dismissed/` memory
5. **Bluesky-present voices are preferred** — Tyler can act on the suggestion immediately by following them

### Saturation rule

Stop including the Discovery section when any of:
- Tyler hasn't engaged with a discovered voice in the last 14 days (signal: discovery isn't landing)
- More than 30 voices have been surfaced cumulatively without Tyler adopting any (signal: well is dry or Tyler is saturated)
- Tyler explicitly says "stop discovery" or similar

When gated off, simply omit the section. Reappears later if Tyler asks ("any new voices worth following?") or organically when AINews quotes someone genuinely novel and Bluesky-present.

### Discovery memory state

- `voices/known/<handle>` — explicitly engaged with (followed, replied to, told you about)
- `voices/surfaced/<handle>` — already shown by digest (don't re-surface unless they post something significantly notable weeks later)
- `voices/dismissed/<handle>` — Tyler explicitly told the agent to stop surfacing

### Format

When included, exactly 1-2 voices per digest:

```
**Worth a follow check:**
- [Handle Name (@handle.bsky.social)](link to bsky profile): one-line characterization +
  link to the specific post that surfaced them
```

## Cross-day deduplication

Before composing, check `feed-digest/surfaced/<last-7-days>` memory namespace. Skip any URL or canonical headline that's been surfaced in the last 7 days. **Same story re-appearing daily is the #1 noise pattern** — strict dedup is non-negotiable.

After composing, write each surfaced item's URL + canonical headline to `feed-digest/surfaced/<today>`.

Edge case: a *follow-up* story to something previously surfaced (e.g. "Anthropic responded to last week's leaked memo") is fine to include. Match on canonical headline, not loose subject overlap.

## Output format

Discord message. Variable length (no hard cap), tuned for ~15-30 min coffee-read.

```
<N> items across <M> themes today.

**<Theme 1 from AINews>**
2-3 sentences synthesizing. Inline links to specific posts.

**<Theme 2 from AINews>**
...

**Pulse**
1-3 items from Reddit / GitHub trending / Bluesky. Mix sources.
Memes welcome. Short blurbs (1-2 sentences each).

**Worth a longer read:**
- [Specific post title](link) — why
- [Another](link) — why

**Worth a follow check:** (omit when saturation gate fires)
- [@handle.bsky.social](link): characterization
```

### Tone

- Conversational, not breathless. No exclamation marks unless they're actually warranted.
- Pulse should sound different from Spine — looser, more human. If a meme is funny, you can say it's funny.
- Don't pad. If a section is empty (`Quiet pulse today`, `Quiet on long-form`), say so. The user trusts honesty more than artificial fullness.
- Don't editorialize beyond the relevance lens. Surface, summarize, link. Tyler decides.

## Hard rules / pitfalls

- **Recency**: every item must be within last 24h (48h max for AINews's own edition). HN points are not a recency proxy.
- **Dedup**: check `feed-digest/surfaced/*` memory; skip anything seen in last 7 days unless it's a true follow-up story.
- **Pulse must surface ≥1 item or explicitly say it's quiet**. Never silently omit.
- **Don't fabricate links**. If a fetch failed, omit that source for the day and note it (`Bluesky fetch unavailable today`) so the user knows whether the source had nothing or whether the agent couldn't reach it.
- **Don't summarize the same story twice across tiers**. If AINews and r/LocalLLaMA both have the Uber story, pick the better-written source (likely AINews) and skip the other.
- **Don't include news commentary that lacks AI engineering substance** — "OpenAI announced X" without analysis is just a press release; skip.

## Verification

- Tyler reads the digest most mornings (≥4 days/week by week 2)
- At least one "Worth a longer read" link clicked per week
- Pulse genuinely lands as cultural-vitamin content — Tyler doesn't say "the memes are weak"
- Discovery either produces voices Tyler engages with, OR self-quiets per the saturation rule. The failure mode is "discovery keeps surfacing voices Tyler ignores" — that's the rule's job to prevent.
- Tyler doesn't say "this digest is noise" or stop asking for it. If he does, retune filtering or cull a feed.

## When in doubt

When a source produces nothing or is unreachable, **say so explicitly** rather than silently dropping. The user reading the digest needs to know whether silence means "nothing happened" or "fetch failed" — these are very different states.

When uncertain about an item's relevance, lean toward including it in Pulse rather than Spine. Pulse tolerates more variance; Spine should be high-confidence.

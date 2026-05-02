---
name: feed-digest
description: Daily AI engineering digest mixing long-form signal (blogs, HN, Medium), social-media pulse (Bluesky, X-when-feasible, Reddit AI subs), and personality discovery (new voices Tyler hasn't seen). Output is a Discord message Tyler can scan in 2 minutes and decide what to dig into.
version: 0.2
when_to_use: |
  Trigger when Tyler asks for a daily/morning digest. Phrases:
    - "what's new"
    - "morning digest" / "give me the digest" / "the digest"
    - "what should I read today"
    - "summarize the feeds"
    - "what's happening in AI today"

  Frequency: roughly daily, mornings. Skill has state (tracks voices already
  surfaced) so don't worry about repetition across days.
---

# Feed Digest

Daily AI engineering scan. Three tiers, mixed in a single Discord message.

## Tier 1 — Signal (long-form, ~60% of digest)

Reliable RSS-based long-form. Always include if items are fresh.

- [Simon Willison](https://simonwillison.net/atom/everything/) — practitioner notes, Anthropic/OpenAI/Google watch
- [Latent Space](https://www.latent.space/feed) — interviews, scene-of-the-week
- [Interconnects (Nathan Lambert)](https://www.interconnects.ai/feed) — model release analysis, RL/post-training depth
- [One Useful Thing (Ethan Mollick)](https://www.oneusefulthing.org/feed) — practical applied AI, education-flavored
- [Eugene Yan](https://eugeneyan.com/rss) — applied ML writing, evals
- [Hamel Husain](https://hamel.dev/feed.xml) — fine-tuning, evals, consultant-honest takes
- [Sebastian Raschka](https://magazine.sebastianraschka.com/feed) — research breakdowns, accessible math
- [HN AI search RSS](https://hnrss.org/newest?q=AI+OR+LLM+OR+agent&points=50) — top AI-tagged stories with ≥50 points

## Tier 2 — Pulse (short-form / social, ~30% of digest)

Trending discussion + shitposts + hot takes. Mix of platforms.

- **Bluesky** — Tyler's handle: `@ohhheytyler.bsky.social`. **His follow list is sparse and growing.** Don't rely solely on his home feed. Strategy:
    1. Fetch his home feed (`bsky.app/profile/ohhheytyler.bsky.social/feed.rss` or via AT Protocol public API at `public.api.bsky.app/xrpc/app.bsky.feed.getAuthorFeed?actor=ohhheytyler.bsky.social`) — small but real signal
    2. Fetch AI engineering starter packs — these are publicly curated follow lists. Search for ones tagged "AI engineering", "ML", "agents". Pull trending posts from accounts in those packs even though Tyler doesn't follow them yet
    3. Fetch posts via AT Protocol search by hashtag — `#aiengineering`, `#llm`, `#agents`, `#mlops` — last 24h, top by engagement
    4. The Discovery tier (Tier 3 below) **directly serves the goal of growing Tyler's follow list** — surface 1-2 new voices per digest with the explicit framing of "would it be worth following X?"
- **Reddit r/LocalLLaMA RSS**: https://www.reddit.com/r/LocalLLaMA/.rss — local-AI community, lots of meme/shitpost energy mixed with serious work
- **Reddit r/MachineLearning RSS**: https://www.reddit.com/r/MachineLearning/.rss — broader research-flavored discussion
- **X / Twitter**: **out of scope for v0.2**. Tyler doesn't have a good answer for the X gap; neither do I. Reality:
    - X scrapers (Nitter, third-party APIs) are unreliable or dead in 2026
    - Paid X API ($100+/mo) is overkill for Phase 0
    - ~60% of cultural-vitamin voices (Dax Raad, Ken Wheeler, etc.) cross-post to Bluesky, so the Bluesky path covers most of what would otherwise be lost
    - Critical X threads still surface via blog quotes, Bluesky cross-references, and HN. Links are useful even when the thread itself isn't fetchable
    - Revisit in Phase 1 if Bluesky-only signal proves insufficient. Until then, accept the gap; don't hack around it

Cultural vitamin accounts to surface from when they post anything in the last 24h (these are the "fun side of the field" voices Tyler explicitly wants in the mix):

- Dax Raad (`@thdxr` on X, also on Bluesky) — OpenCode, agentic coding, reliable shitposting
- Ken Wheeler (`@ken_wheeler` on X / Bluesky) — frontend/AI bridge, sharp memes
- Theo (`@theo` on X / `@t3dotgg`) — opinionated, loud, occasionally informative
- Geoffrey Huntley (`@GeoffreyHuntley` X/Bluesky) — AI coding agents, builds in public
- Swyx (`@swyx` X/Bluesky) — Latent Space, AI Engineer
- Simon Willison (already in Tier 1 long-form, but his short posts also count)

Surface 1-2 of these per digest if they posted; don't force all of them.

## Tier 3 — Discovery (new voices, ~10% of digest, conditional)

Goal: surface AI engineering personalities Tyler hasn't seen before, *signal-capped*. Stop pushing new follows once Tyler's saturation point is reached.

**Discovery is doubly important right now** because Tyler's Bluesky follow graph is sparse — Discovery is the active mechanism for growing it. Bias toward voices that are active on Bluesky (so Tyler can act on the suggestion immediately by following) over X-only voices (which he can't easily act on anyway).

### How to identify a discovery candidate

A voice is a discovery candidate if:
1. They're quoted, reposted, or quote-replied by a Tier 1 or Tier 2 source in the last 24h
2. Their post has substantive AI engineering content (not just news commentary)
3. They are NOT in Tyler's known-voices memory (`voices/known/`)
4. They are NOT in Tyler's dismissed-voices memory (`voices/dismissed/`)

### How to track saturation

Maintain memory under `voices/`:
- `voices/known/<handle>` — voices Tyler has explicitly engaged with (followed, replied to, or said "yeah I follow them")
- `voices/surfaced/<handle>` — voices the digest has already surfaced (so we don't re-surface them daily; surface again only if they have a *significantly* notable post weeks later)
- `voices/dismissed/<handle>` — voices Tyler has explicitly told the agent to stop surfacing ("not interested in X")

### Saturation rule

**Stop including the Discovery section** when any of:
- Tyler hasn't engaged with a discovered voice in the last 14 days (signal: discovery isn't landing)
- More than 30 voices have been surfaced cumulatively without Tyler adopting any (signal: the well is dry or Tyler is saturated)
- Tyler explicitly says "stop discovery" or similar

In that case, the digest is just Tier 1 + Tier 2. The Discovery section reappears later if Tyler asks ("any new voices worth following?") or organically when a Tier 1 source quotes someone genuinely novel.

### Discovery output format

When included, exactly 1-2 voices per digest:

```
**Worth a follow check:**
- [Handle Name (@handle)](link to platform): one-line characterization + link to the
  specific post that surfaced them
```

## Procedure

1. **Fetch all Tier 1 RSS feeds** (parallel where possible). Filter to items from the last 24h.

2. **Fetch Tier 2 sources** that are accessible. Bluesky public feeds via `bsky.app/profile/<handle>/rss` or AT Protocol public API. Reddit `.rss` endpoints. Skip X unless a Tier 1 source already linked an X thread (in which case the link is enough).

3. **Score and cluster**:
   - Score Tier 1 items for relevance to: AI engineering (LLMs, agents, evals, model releases, tooling, infra) and woodworking-business cross-overs (rare but include if they appear)
   - Cluster by theme — don't go item-by-item; surface 2-4 themes max
   - Pick 1-2 cultural-vitamin posts from the Tier 2 personality list if they posted

4. **Discovery scan**: scan Tier 1 and Tier 2 fetches for candidate voices per the rules above. Apply saturation gate. If discovery surfaces a candidate, prepare the format.

5. **Compose** the Discord message:

   ```
   <N> items across <M> themes today.

   **<Theme 1 title>**
   2-3 sentences synthesizing the long-form items in this theme. Inline links
   to specific posts where relevant.

   **<Theme 2 title>**
   ...

   **Pulse**
   1-3 short blurbs from social/Reddit. Cultural-vitamin posts go here. 1-2 sentences each.

   **Worth a longer read:**
   - [Specific post title](link) — why
   - [Another](link) — why

   **Worth a follow check:** (omit this section if discovery is gated off)
   - [@handle](link): characterization
   ```

6. **Update memory**:
   - For any voice surfaced in Discovery, write to `voices/surfaced/<handle>` with timestamp
   - For any voice surfaced in Pulse from the cultural-vitamin list, no memory write needed (already known-known)

## Length and tone

- Total under ~600 words (longer than original since Pulse adds material)
- Discord markdown: `**bold**` for section titles, inline `[link text](url)`. No nested headers, no tables, no emoji headers.
- Tone: conversational and confident. Not breathless. Tyler doesn't need exclamation marks.
- If a section is empty (e.g. quiet morning, no fresh long-form), say so explicitly: `Quiet on the long-form side today.` Don't pad.

## Pitfalls

- **Don't list every item.** Synthesis, not enumeration. If 6 items in a theme, pick the 2 worth surfacing.
- **Don't summarize the same story twice** if it appears in multiple feeds. Pick the better-written source.
- **Don't fabricate links.** If a fetch failed, omit that source for the day and note `(Bluesky fetch unavailable today)` if it materially affects the digest.
- **Don't push discovery if the saturation rule fires.** Respect Tyler's "stop forcing follows" preference.
- **Don't include news commentary that lacks AI engineering substance** — "OpenAI announced X" without analysis is just a press release, skip.
- **Don't cluster a single item under its own theme.** A theme needs ≥2 items, or it's just a callout.

## Verification

- Tyler reads the digest most mornings (≥4 days/week by week 2)
- At least one "Worth a longer read" link clicked per week
- Discovery section either: produces voices Tyler engages with, OR self-quiets per the saturation rule. The failure mode is "discovery keeps surfacing voices Tyler ignores indefinitely" — that's the rule's job to prevent.
- Tyler doesn't say "this digest is noise" or stop asking for it. If he does, retune filtering or cull a feed.

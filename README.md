# STEAL THE HOUSE!

A 3D Roblox co-op heist-survival game where tiny players steal oversized loot from giant houses, manage noise, escape awakened threats, and build a collection of rare items.

> **Steal giant loot. Stay quiet. RUN when the house wakes up.**

## Product goal

Build a Roblox experience whose first 15 minutes are understandable without a long tutorial and strong enough that a new player voluntarily starts a second run.

## Core loop

1. Enter the house.
2. Find and carry loot.
3. Take bigger risks as the Noise meter rises.
4. Survive the House Wake-Up chase.
5. Extract and sell or collect loot.
6. Upgrade Strength, Speed, and Sneak.
7. Unlock deeper rooms and rarer loot.
8. Repeat with friends.

## First vertical slice

The first playable slice is intentionally small:

- one stylized oversized house;
- one enemy: **Mr. Whiskers** the cat;
- ~20 loot items;
- server-authoritative grab/carry/drop;
- Noise → Wake-Up → Chase → Escape loop;
- extraction and basic economy;
- Strength / Speed / Sneak upgrades;
- co-op heavy-item carrying and teammate rescue;
- mobile-first controls;
- onboarding + retention analytics.

## Development principles

- **Fun before content:** prove the loop before building more worlds.
- **Mobile first:** every critical action must work comfortably on a phone.
- **Server authority:** clients request actions; the server validates economy, loot, rewards, and important interactions.
- **Fast onboarding:** first meaningful reward in under a minute; first high-tension moment in the opening minutes.
- **Measure before scaling:** retention and second-run rate decide whether we add content.
- **No pay-to-win core progression:** monetization should primarily amplify identity, expression, and convenience without invalidating gameplay.

## Planned toolchain

- Roblox Studio
- Luau
- Rojo
- Git + GitHub
- StyLua
- Selene
- TestEZ where automated tests add real value

## Project docs

- [MVP roadmap](docs/roadmap.md)
- [Development workflow](docs/development-workflow.md)
- [Feature issue template](.github/ISSUE_TEMPLATE/feature.md)
- [Pull request template](.github/pull_request_template.md)
- [GitHub metadata setup](scripts/setup-github-metadata.sh)

## Roadmap

GitHub Issues are the source of truth for implementation. The current MVP backlog is **#1–#34**, grouped into phases `M0` through `M6`. Product vision, weekly planning, budget, KPIs, risks, experiments, and release gates live in Notion.

Actual GitHub labels and milestones can be provisioned idempotently after cloning with:

```bash
bash scripts/setup-github-metadata.sh
```

## Status

**Pre-production / M0 — Project Foundation**

Start with **#1 — Bootstrap Roblox + Rojo project and local toolchain**.

# Development Workflow

## Source of truth

- GitHub Issues define implementation scope and acceptance criteria.
- Notion defines product direction, weekly roadmap, budget, KPIs, risks, decisions, and experiments.
- `main` must remain playable.

## Branching

Create one branch per issue:

- `feat/<issue>-short-name`
- `fix/<issue>-short-name`
- `docs/<issue>-short-name`
- `chore/<issue>-short-name`

Examples:

- `feat/1-bootstrap-rojo-project`
- `feat/6-grab-carry-drop`
- `fix/18-cat-pathfinding-stuck`

## Pull requests

Every implementation issue should normally be delivered through a PR.

Before opening a PR:

1. sync from `main`;
2. run formatter and linter;
3. run automated tests that apply;
4. test the affected flow in Roblox Studio;
5. test touch controls when gameplay/UI changed;
6. review the diff for generated files, debug code, secrets, and unrelated changes.

PR description should include:

- what changed;
- why it changed;
- how to test it;
- screenshots/video for visible gameplay/UI changes;
- risk or follow-up work;
- `Closes #<issue>` when complete.

## Gameplay engineering rules

- The server owns authoritative state for rewards, currency, loot ownership, upgrades, extraction results, and progression.
- RemoteEvents/RemoteFunctions are treated as untrusted input.
- Clients may predict presentation, but never decide authoritative rewards.
- Prefer small modules with explicit responsibilities over large all-purpose scripts.
- Tune important gameplay numbers from configuration modules rather than scattering literals across scripts.
- Avoid adding a system until the current vertical slice proves it needs one.

## Mobile-first rule

A feature is not complete if it only feels good with mouse and keyboard.

For gameplay changes verify:

- readable UI on a phone viewport;
- comfortable touch target sizes;
- no required hover state;
- camera and character controls do not fight interaction buttons;
- core action count remains small.

## Definition of Done

An issue is Done only when:

- acceptance criteria are satisfied;
- code is formatted/linted;
- relevant automated tests pass;
- manual Roblox Studio test passes;
- mobile is tested when applicable;
- server/client trust boundaries are reviewed when applicable;
- no known P0/P1 regression is introduced;
- documentation/configuration is updated if behavior changed.

## Scope discipline

The MVP is not a content race. New worlds, cosmetics, large monetization systems, battle passes, pets, trading, and elaborate hideouts stay out until the first-house loop demonstrates strong playtest retention.

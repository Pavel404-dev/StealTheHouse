# MVP Roadmap

The implementation backlog is intentionally validation-first. New worlds and large meta systems stay out until Closed Alpha proves the first-house loop.

## M0 — Foundation

- #1 Bootstrap Roblox + Rojo project and local toolchain
- #2 Establish module layout, shared contracts, and gameplay configuration conventions
- #3 Add CI quality gates for formatting, linting, and tests
- #4 Create graybox test place and multiplayer test harness

## M1 — Interaction

- #5 Define server-authoritative interaction protocol
- #6 Implement single-player grab, carry, and drop
- #7 Add loot weight classes and carry movement penalties
- #8 Implement mobile-first Grab, Sprint, and Gadget input shell
- #9 Harden interaction remotes with validation, cooldowns, and exploit guards

## M2 — First House Vertical Slice

- #10 Build House 01 graybox and readable traversal routes
- #11 Define the first 20 loot items and deterministic spawn system
- #12 Implement extraction zone and server-authoritative loot banking
- #13 Implement run lifecycle and authoritative game-state machine
- #14 Build first HUD for loot, value, run phase, and extraction feedback

## M3 — Noise & Chase

- #15 Implement server-authoritative Noise system
- #16 Implement House Wake-Up transition and tension presentation
- #17 Implement Mr. Whiskers AI states and chase navigation
- #18 Implement downed, caught, escape, and run outcome rules
- #19 Add teammate rescue interaction during chase

## M4 — Co-op

- #20 Implement two-player heavy-object carrying
- #21 Generalize team carrying for 3–6 player special loot
- #22 Harden carried-object replication and network ownership
- #23 Define co-op reward attribution and anti-grief rules

## M5 — Progression & Persistence

- #24 Implement server-authoritative currency and run reward settlement
- #25 Implement Strength, Speed, and Sneak upgrade progression
- #26 Implement versioned player profile persistence with DataStore
- #27 Add persistence session locking, retries, and corruption-safe recovery
- #28 Implement Basement Key progression and first-session room unlock
- #29 Add loot rarity tiers and mutation variants

## M6 — Alpha Validation

- #30 Instrument first-15-minute funnel and core retention events
- #31 Script and tune the first 15 minutes of onboarding
- #32 Add closed-alpha developer and playtest controls
- #33 Run mobile and low-end performance optimization pass
- #34 Prepare and run Closed Alpha with explicit release gates

## Product gate

Do **not** promote Mansion, School, pets, trading, battle pass, a large hideout system, or broad LiveOps into active implementation before the Closed Alpha review unless the feature directly fixes a measured MVP problem.

## North star

A fresh player should understand the game quickly, experience the signature `Noise → House Wake-Up → Chase` moment, feel meaningful progression, and voluntarily start a second run.

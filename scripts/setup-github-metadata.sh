#!/usr/bin/env bash
set -euo pipefail

REPO="Pavel404-dev/StealTheHouse"

create_label() {
  local name="$1" color="$2" description="$3"
  gh label create "$name" --repo "$REPO" --color "$color" --description "$description" --force >/dev/null
}

ensure_milestone() {
  local title="$1" description="$2"
  local number
  number="$(gh api --paginate "repos/$REPO/milestones?state=all&per_page=100" --jq ".[] | select(.title == \"$title\") | .number" | head -n1)"
  if [[ -z "$number" ]]; then
    gh api --method POST "repos/$REPO/milestones" -f title="$title" -f description="$description" --jq '.number'
  else
    printf '%s\n' "$number"
  fi
}

apply_range() {
  local start="$1" end="$2" milestone="$3" label="$4"
  local issue
  for issue in $(seq "$start" "$end"); do
    gh issue edit "$issue" --repo "$REPO" --milestone "$milestone" --add-label "$label" --add-label "type:feature" >/dev/null
  done
}

printf 'Creating labels...\n'
create_label "type:feature" "1D76DB" "Product/gameplay feature or enabling implementation"
create_label "type:bug" "D73A4A" "Bug or regression"
create_label "type:chore" "6E7781" "Maintenance/tooling work"
create_label "priority:P0" "B60205" "Release/blocking: fix immediately"
create_label "priority:P1" "D93F0B" "High priority"
create_label "priority:P2" "FBCA04" "Normal priority"
create_label "area:gameplay" "F59E0B" "Core gameplay systems"
create_label "area:multiplayer" "8250DF" "Replication/co-op/networking"
create_label "area:ui" "EC4899" "UI/UX and input"
create_label "area:data" "EF4444" "Persistence and player data"
create_label "area:analytics" "0EA5E9" "Telemetry, KPI and experiments"
create_label "area:tooling" "64748B" "Developer workflow/toolchain"
create_label "platform:mobile" "22C55E" "Requires explicit mobile/touch validation"
create_label "security" "7C3AED" "Server/client trust boundary or exploit hardening"

create_label "phase:M0" "6E7781" "M0 — Foundation"
create_label "phase:M1" "2563EB" "M1 — Interaction"
create_label "phase:M2" "16A34A" "M2 — First House Vertical Slice"
create_label "phase:M3" "EA580C" "M3 — Noise & Chase"
create_label "phase:M4" "7C3AED" "M4 — Co-op"
create_label "phase:M5" "DB2777" "M5 — Progression & Persistence"
create_label "phase:M6" "DC2626" "M6 — Alpha Validation"

printf 'Creating milestones if missing...\n'
ensure_milestone "M0 — Foundation" "Reproducible Roblox/Rojo project, CI and multiplayer test harness." >/dev/null
ensure_milestone "M1 — Interaction" "Server-authoritative grab/carry/drop, weight, mobile controls and exploit guards." >/dev/null
ensure_milestone "M2 — First House Vertical Slice" "House 01, loot, extraction, run lifecycle and first HUD." >/dev/null
ensure_milestone "M3 — Noise & Chase" "Noise, House Wake-Up, Mr. Whiskers, chase outcomes and rescue." >/dev/null
ensure_milestone "M4 — Co-op" "Stable team carry, replication and fair co-op reward rules." >/dev/null
ensure_milestone "M5 — Progression & Persistence" "Currency, upgrades, DataStore, Basement Key and rarity/mutations." >/dev/null
ensure_milestone "M6 — Alpha Validation" "Analytics, onboarding, playtest controls, performance and Closed Alpha." >/dev/null

printf 'Applying phase milestones/labels...\n'
apply_range 1 4 "M0 — Foundation" "phase:M0"
apply_range 5 9 "M1 — Interaction" "phase:M1"
apply_range 10 14 "M2 — First House Vertical Slice" "phase:M2"
apply_range 15 19 "M3 — Noise & Chase" "phase:M3"
apply_range 20 23 "M4 — Co-op" "phase:M4"
apply_range 24 29 "M5 — Progression & Persistence" "phase:M5"
apply_range 30 34 "M6 — Alpha Validation" "phase:M6"

printf 'Applying cross-cutting labels...\n'
for issue in 1 2 3 4 32; do gh issue edit "$issue" --repo "$REPO" --add-label "area:tooling" >/dev/null; done
for issue in 5 6 7 10 11 12 13 15 16 17 18 19 24 25 28 29 31; do gh issue edit "$issue" --repo "$REPO" --add-label "area:gameplay" >/dev/null; done
for issue in 4 5 6 9 13 17 18 19 20 21 22 23 34; do gh issue edit "$issue" --repo "$REPO" --add-label "area:multiplayer" >/dev/null; done
for issue in 8 14 16 19 25 28 31 33; do gh issue edit "$issue" --repo "$REPO" --add-label "area:ui" >/dev/null; done
for issue in 26 27; do gh issue edit "$issue" --repo "$REPO" --add-label "area:data" >/dev/null; done
for issue in 30 31 34; do gh issue edit "$issue" --repo "$REPO" --add-label "area:analytics" >/dev/null; done
for issue in 8 10 14 19 20 31 33 34; do gh issue edit "$issue" --repo "$REPO" --add-label "platform:mobile" >/dev/null; done
for issue in 5 9 12 20 21 22 23 24 25 26 27 28 29 32; do gh issue edit "$issue" --repo "$REPO" --add-label "security" >/dev/null; done

# Initial priority: start only with #1; high-priority labels reflect sequencing, not simultaneous work.
gh issue edit 1 --repo "$REPO" --add-label "priority:P0" >/dev/null
for issue in 2 3 4 5 6 7 8 9; do gh issue edit "$issue" --repo "$REPO" --add-label "priority:P1" >/dev/null; done
for issue in $(seq 10 34); do gh issue edit "$issue" --repo "$REPO" --add-label "priority:P2" >/dev/null; done

printf 'GitHub metadata setup complete for %s.\n' "$REPO"

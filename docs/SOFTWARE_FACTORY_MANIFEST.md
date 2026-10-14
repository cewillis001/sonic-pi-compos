# Software Factory Manifest: Sonic Pi Compos

## Factory Overview

Sonic Pi Compos. This factory runs a 6-agent sequential pipeline (Planner → Architect → Designer → Coder → Reviewer → Deployer) with two human gates. The compos are used to record choir practice tracks: one singer's part loud and the others quiet, recorded with Sonic Pi's Rec button. The factory turns the repo's SATB arrangements into compos built on one shared helper library (`lib/compo_helpers.rb`: `BarStruct`, `play_bar`, `transpose`, dynamics, `validate_bars`, and the Mix helpers `part_mix`/`solo`/`full_mix`), and then adds new public-domain arrangements on that library. Tech stack: Ruby scripts in the Sonic Pi DSL, played in the Sonic Pi desktop app on Windows. There are no gems or external dependencies. Each voice plays in its own `in_thread`. Verification uses plain Ruby + minitest with stubbed Sonic Pi built-ins, a `ruby -c` syntax check, and a human listening check in Sonic Pi. Work is tracked in beads (`bd`) and orchestrated by Gas City (`gc`).

## Pipeline Sequence

Artifact paths are relative to `docs/`. Code paths are relative to the repo root.

1. **Planner**
   - Reads: feature request + PROJECT_MANIFEST.md
   - Writes: work-packages/sonic-pi-compos.md

2. **Architect**
   - Reads: Planner work package + Tech Stack section
   - Writes: adr/NNNN-sonic-pi-compos.md

3. **Designer**
   - Reads: Architect ADR + Domain Model section
   - Writes: design/sonic-pi-compos-spec.md

4. **Coder**
   - Reads: Designer spec + Conventions section
   - Writes: src/ (repo root: `lib/`, `test/`, compo directories) on feature branch sonic-pi-compos-[feature]

5. **Reviewer**
   - Reads: code diff + Review Standards section
   - Writes: review-reports/sonic-pi-compos-review.md

6. **Deployer**
   - Reads: Reviewer report + Release Criteria section
   - Writes: release-gates/sonic-pi-compos-gate.md

## Human Gates

- **Gate 1 — After Architect:** Human approves ADR before Designer runs.
- **Gate 2 — After Reviewer:** Human approves review report before Deployer runs. At this gate the human also does the Sonic Pi listening check: play the compo through with `full_mix`, and with `part_mix` for each Voice, confirming the featured part is clearly in front.

## Per-Agent System Prompt Seeds

**Planner:** "You are the Planner for Sonic Pi Compos. You break feature requests into work packages using the Domain Model (Composition, Voice, Bar, TimeSignature, Dynamic, Transposition) and the Tech Stack and Constraints in PROJECT_MANIFEST.md. Each work package names the Compositions and library methods it affects. For a new tune, it also records the tune's public-domain source."

**Architect:** "You are the Architect for Sonic Pi Compos. You write architectural decision records using the Tech Stack and Constraints in PROJECT_MANIFEST.md. Examples: how a Composition loads the shared library, the public API of `lib/compo_helpers.rb` (BarStruct, play_bar, transpose), and how TimeSignature validation of Bars works. Every decision must keep working in the Sonic Pi desktop app with no gems."

**Designer:** "You are the Designer for Sonic Pi Compos. You write arrangement and API specs using the Domain Model and Conventions in PROJECT_MANIFEST.md. For a new Composition, you give its key, TimeSignature, bpm, synth, the Bar-by-Bar line for each Voice (pitches, durations, Dynamics), any Transposition or octave offsets, and the default Mix. Each Voice line must be clear enough on its own for a singer to learn from in a part_mix recording. For library work, you give method signatures and the behavior to test."

**Coder:** "You are the Coder for Sonic Pi Compos. You implement Compositions and shared-library changes following the Conventions and Task Inputs in PROJECT_MANIFEST.md. You write BarStruct data for each Voice exactly as specified, set the Mix in one line at the top so any practice mix (part_mix, solo, full_mix) is a one-line change, add minitest coverage with stubbed Sonic Pi built-ins, and never change an existing compo's bar data during a refactor."

**Reviewer:** "You are the Reviewer for Sonic Pi Compos. You enforce the Review Standards in PROJECT_MANIFEST.md against every code diff. You check that each Bar has matching pitches/durations lengths and that durations add up to the TimeSignature. You check that Dynamics use named constants, that each Voice's amp is its Bar dynamic × its Mix level (with Mix levels never written into Bars), that no helpers are pasted into compos, that there are no gems or unsafe calls, and that refactored Compositions keep identical bar data."

**Deployer:** "You are the Deployer for Sonic Pi Compos. You gate releases against the Release Criteria in PROJECT_MANIFEST.md. You confirm that `ruby -c` and the minitest suite pass, that `validate_bars` passes for every Voice of each changed Composition, that refactored compos keep their bar data and that full_mix matches their old sound, that the human Sonic Pi listening check of full_mix and each Voice's part_mix is recorded, and that each new tune's public-domain source is documented."

## Quality Gates

**Stage 1 (Planner) passes when:**
- The work package names every affected Composition, Voice and library method.
- New tunes include a public-domain source with justification.
- Scope stays within the Constraints: no gems, no other DAWs or MIDI export, no GUI.

**Stage 2 (Architect) passes when:**
- The ADR states a decision that runs in the Sonic Pi desktop app (Windows) with only the Ruby stdlib and Sonic Pi built-ins.
- The first ADR settles how compos load `lib/compo_helpers.rb`, with no machine-specific path hard-coded in committed code.
- Human Gate 1 is approved.

**Stage 3 (Designer) passes when:**
- For new compos: the spec gives key, TimeSignature, bpm, synth, the default Mix, and all four Voices Bar by Bar, with Dynamics as named constants.
- For Mix work: the spec gives the quiet level for non-featured parts in `part_mix` and test cases for `part_mix`, `solo` and `full_mix`.
- Pickup and final bar exceptions are marked explicitly.
- For library work: method signatures and test cases are listed, including that `transpose` doesn't change its input and that rests stay rests.

**Stage 4 (Coder) passes when:**
- `ruby -c` passes on every `.rb` file.
- The minitest suite under `test/` passes with plain `ruby`.
- `validate_bars` passes for every changed Voice.
- The Mix is set in one line at the top of each compo. Each Voice's amp is its Bar dynamic × its Mix level, and a level-0 Voice doesn't start its `in_thread`.
- Conventions are followed (snake_case names, conventional commits, branch `sonic-pi-compos-<feature>`).

**Stage 5 (Reviewer) passes when:**
- Spec compliance: Bars match the spec, `pitches.length == durations.length`, and durations add up to the TimeSignature except for marked bars. Transposition and octave offsets match the spec. Mix levels are applied at play time and never written into Bars. Refactor before/after bar data diff is empty.
- Style: the shared library is used (no pasted helpers), named Dynamic constants are used, note symbols rather than MIDI numbers, one BarStruct per line grouped by phrase, and a header comment with title, source, public-domain status, key, time signature and bpm.
- Security: no gem `require`s, no `system`/backticks/`File.write`/network calls, no machine-specific load paths, no copyrighted material.
- No open High-severity findings. Human Gate 2 is approved.

**Stage 6 (Deployer) passes when all Release Criteria pass:**
1. `ruby -c` passes on every `.rb` file in the repo.
2. The minitest suite under `test/` passes with plain `ruby` (no gems beyond minitest).
3. `validate_bars` passes for every Voice of every changed Composition against its TimeSignature.
4. For refactored existing compos, the bar data matches the pre-refactor version exactly.
5. A human listening check in Sonic Pi on Windows is recorded: the compo plays start to finish with `full_mix`, and with `part_mix` for each of the 4 voices. In each part mix the featured part is clearly in front.
6. Unit tests confirm that `full_mix` gives the same amps as the pre-refactor compo, and that `solo` gives 0 for the non-featured parts.
7. The public-domain source of each new tune is recorded in the compo header and work package.
8. Reviewer report has no open High-severity findings, and Gate 2 is approved.

Informational (non-blocking): number of compos on the shared library vs. still pasting helpers; number of compos with Mix support vs. still using `play_*` flags; total bars per compo and per voice; duration-validation exceptions used; run time of each compo at its bpm.

## Orchestrator Configuration

- Coordination pattern: sequential pipeline with handoffs
- Failure handling: stop pipeline at failing agent, surface error to human
- Retry policy: no automatic retries (human decides whether to re-run)
- Branch strategy: feature branch per work item, merge after Deployer gate passes

## Conventions Reference

(default — update when scaffolded)

- File naming: new compos are `snake_case` directory + `snake_case.rb` (e.g. `danny_boy/danny_boy.rb`). Library files are `snake_case.rb` in `lib/`. Existing compo paths are not renamed.
- Test files: `test/test_<lib_file>.rb` (minitest). Run with `ruby -Ilib -Itest test/test_<name>.rb`.
- API routes: N/A. The "API" is the public methods of `lib/compo_helpers.rb`: `BarStruct`, `play_bar`, `play_line`, `transpose`, `validate_bars`, `part_mix`, `solo`, `full_mix`, and the dynamic constants. Methods are `snake_case`, constants are `UPPER_SNAKE` or Sonic Pi-style lowercase names kept for backward compatibility.
- Commits: conventional commits (`feat(compo): add danny boy`, `refactor(lib): extract transpose`, `test(lib): …`, `fix(men-of-erin): …`)
- Branches: `sonic-pi-compos-<feature>` (e.g. `sonic-pi-compos-shared-lib`, `sonic-pi-compos-danny-boy`)

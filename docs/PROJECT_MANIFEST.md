# Project Manifest: Sonic Pi Compos

## Overview

Sonic Pi Compos (cewillis001) is a repo of "compos": four-part (soprano, alto, tenor, bass) arrangements of traditional and folk tunes, written as Ruby scripts for the Sonic Pi live-coding music app. Listeners clone the repo, open a `.rb` file in the Sonic Pi desktop editor (Windows), and click Run. The repo has five compos: *Men of Erin*, *Over the Sea to Skye*, *A Lusty Young Smith*, *Still Still Still* and *The Parting Glass*. It also has `4partSongTemplate.rb`. Right now each compo pastes its own copy of the helpers (`play_bar`, `BarStruct`, `transpose`, dynamic constants). The goal is to pull those helpers into one shared library that every compo loads, and then use the factory to add new public-domain arrangements built on that library. The users are the author (composing and arranging) and listeners who run the compos in Sonic Pi.

## Tech Stack

| Layer    | Technology | Notes |
|----------|-----------|-------|
| Frontend | Sonic Pi desktop app (Windows) | The runtime and player. A compo is opened in an editor buffer and run there. There is no other UI. |
| Styling  | N/A | Audio only. "Style" means synth choice (`use_synth :piano`) and dynamics. |
| State    | Ruby constants and flags in each compo | `play_soprano`/`play_alto`/`play_tenor`/`play_bass` toggles, dynamic amp constants, `use_bpm` |
| Routing  | Sonic Pi `in_thread` | Each voice plays in its own thread, all in parallel |
| Backend  | Ruby (Sonic Pi DSL) | Sonic Pi built-ins: `play`, `play_pattern_timed`, `line`, `use_synth`, `use_bpm`, note symbols (`:c4`, `:r`) |
| Database | None | Music data lives in the source as `BarStruct` arrays |
| Testing  | Plain Ruby + minitest | Unit-test the shared library outside Sonic Pi, with stubs for the built-ins (`play`, `play_pattern_timed`, `line`, `note`). Listening in Sonic Pi is a manual check. |
| Linting  | `ruby -c` (syntax check) | Runs on every `.rb` file. RuboCop is optional and must not be needed to play a compo. |

## Project Structure

(proposed — update when scaffolded)

```
sonic-pi-rig/
├── README.md                    # How to install Sonic Pi and play a compo
├── 4partSongTemplate.rb         # SATB starter template (to be updated to load lib/)
├── lib/
│   └── compo_helpers.rb         # Shared library: BarStruct, play_bar, transpose, dynamics, validation
├── test/
│   ├── sonic_pi_stubs.rb        # Stub Sonic Pi built-ins for plain-Ruby tests
│   └── test_compo_helpers.rb    # minitest suite for lib/
├── men of erin/men_of_erin.rb   # Existing compos. Directory names stay as they are.
├── skye boat song/OverTheSeaToSkye.rb
├── a lusty young smith/lustyyoungsmith.rb
├── still still still/still3.rb
├── the parting glass/partingGlass.rb
├── <new_tune>/<new_tune>.rb     # New compos: snake_case dir + file
└── docs/                        # Manifests, ADRs, design specs, factory artifacts
    ├── PROJECT_MANIFEST.md
    ├── SOFTWARE_FACTORY_MANIFEST.md
    ├── adr/
    ├── design/
    ├── work-packages/
    ├── review-reports/
    └── release-gates/
```

## Domain Model

- **Composition**: a single playable `.rb` file.
  - Fields: `title`, `key`, `time_signature` (TimeSignature), `bpm` (`use_bpm`), `synth` (e.g. `:piano`), `voices` (one per SATB part), `transpose_interval` (optional, semitones)
  - Has 4 Voices and 1 TimeSignature
- **TimeSignature**: the meter of a Composition.
  - Fields: `beats_per_bar` (e.g. 3), `beat_unit` (e.g. 4)
  - Used to check that each Bar's `durations` add up to `beats_per_bar`. Pickup (anacrusis) bars and final bars may be short, but only when marked as exceptions.
- **Voice**: one SATB part.
  - Fields: `name` (soprano | alto | tenor | bass), `enabled` (the `play_<name>` flag), `octave_offset` (e.g. tenor written an octave up), `line` (an ordered array of Bars)
  - Plays in its own `in_thread`
- **Bar** (`BarStruct`): one measure of one Voice.
  - Fields: `pitches` (array of note symbols, `:r` = rest), `durations` (array of beats, same length as `pitches`), `dynamic_start`, `dynamic_end` (amp values)
  - Volume is ramped linearly across the bar from `dynamic_start` to `dynamic_end` (`line … inclusive: true`)
- **Dynamic**: a named amp level.
  - `pianissimo` 0.1, `piano` 0.2, `mezzo_piano` 0.3, `mezzo_forte` 0.4, `forte` 0.5, `fortissimo` 0.6
- **Transposition**: an operation, not stored data.
  - `transpose(line, interval)` returns a new line of Bars with every pitch shifted by `interval` semitones. Rests stay rests. The input is not changed.

Relationships: Composition 1→1 TimeSignature. Composition 1→4 Voice. Voice 1→N Bar. Bar uses Dynamic values. Transposition maps a Voice line to a new line.

## Conventions

(default — update when scaffolded)

- File naming: new compos are `snake_case` directory + `snake_case.rb` (e.g. `danny_boy/danny_boy.rb`). Library files are `snake_case.rb` in `lib/`. Existing compo paths are not renamed.
- Test files: `test/test_<lib_file>.rb` (minitest). Run with `ruby -Ilib -Itest test/test_<name>.rb`.
- API routes: N/A. The "API" is the public methods of `lib/compo_helpers.rb`: `BarStruct`, `play_bar`, `play_line`, `transpose`, `validate_bars`, and the dynamic constants. Methods are `snake_case`, constants are `UPPER_SNAKE` or Sonic Pi-style lowercase names kept for backward compatibility.
- Commits: conventional commits (`feat(compo): add danny boy`, `refactor(lib): extract transpose`, `test(lib): …`, `fix(men-of-erin): …`)
- Branches: `sonic-pi-compos-<feature>` (e.g. `sonic-pi-compos-shared-lib`, `sonic-pi-compos-danny-boy`)

## Constraints

- **No gems or external dependencies.** Compos and `lib/` may use only the Ruby standard library and Sonic Pi built-ins. minitest is allowed, but only under `test/`.
- **Public-domain tunes only.** New arrangements must be traditional or public-domain melodies. Each work package records the tune's source and why it is public domain.
- **Don't change existing sound.** Refactoring an existing compo (e.g. moving it onto the shared library) must not change any pitch, duration, dynamic, bpm, synth or voice toggle. Before/after bar data must match exactly.
- **Must run in Sonic Pi desktop (Windows).** No feature may require anything beyond opening the file in Sonic Pi and clicking Run (plus whatever one-time library setup is chosen).
- **Open decision for the Architect:** how compos load `lib/compo_helpers.rb`. Options include Sonic Pi `run_file`/`eval_file` with a user-set path, or a build step that inlines the library. The first ADR must settle this. Pasting the helpers into every file is the current state, not the target.
- Out of scope: other DAWs or MIDI export, a web or GUI front end, live performance tooling, audio file rendering in CI.

---

## Task Inputs

(pipeline-critical — verify before running factory)

| Agent     | Receives                  | From                     |
|-----------|--------------------------|--------------------------|
| Planner   | Feature request (e.g. "arrange *Danny Boy* in SATB" or "extract transpose into lib") + full PROJECT_MANIFEST.md | Human / beads issue |
| Architect | Work package naming the affected Compositions, Voices and library methods + Tech Stack + Constraints | Planner (`docs/work-packages/sonic-pi-compos.md`) |
| Designer  | Approved ADR (library API, how compos load it, TimeSignature validation rules) + Domain Model | Architect (`docs/adr/NNNN-sonic-pi-compos.md`) after Gate 1 |
| Coder     | Design spec: library method signatures, or for a new compo its key, TimeSignature, bpm, synth, the Bar layout for each Voice, and the Dynamic plan + Conventions | Designer (`docs/design/sonic-pi-compos-spec.md`) |
| Reviewer  | Code diff on feature branch + test/`ruby -c` output + Review Standards | Coder (branch `sonic-pi-compos-<feature>`) |
| Deployer  | Review report + human listening sign-off + Release Criteria | Reviewer (`docs/review-reports/sonic-pi-compos-review.md`) after Gate 2 |

## Services to Connect

| Service | Purpose | Config |
|---------|---------|--------|
| GitHub (git) | Source control, feature branches, merge to `master` | Repo `cewillis001` / sonic pi compos. Default branch `master`. |
| beads (`bd`) | Issue / work-item tracking for factory tasks | Already set up (`.beads/`) |
| Gas City (`gc`) | Factory orchestration (agents, dispatch, mail) | Already set up for this rig. `FACTORY_LOG.md` written by `base-factory` orders. |

## Success Criteria

### Per-Feature Success

- [ ] The compo plays clean in Sonic Pi: a human loads it in Sonic Pi on Windows, clicks Run, and it plays start to finish with no errors.
- [ ] Bar durations validate: each Bar's `durations` add up to the Composition's TimeSignature `beats_per_bar`. Pickup and final bars are allowed only when marked. Checked automatically by `validate_bars`.
- [ ] Helper tests pass: the minitest suite for `lib/` passes with plain `ruby`, outside Sonic Pi.
- [ ] All 4 voices are toggleable: soprano, alto, tenor and bass can each be switched on and off on their own with a `play_<voice>` flag.

### Factory-Level Success

- [ ] Every compo, existing and new, loads the shared `lib/compo_helpers.rb` instead of a pasted copy of the helpers.
- [ ] `ruby -c` passes on every `.rb` file, and the full minitest suite passes on a clean checkout with no gems beyond minitest.
- [ ] Existing compos produce the same bar data (pitches, durations, dynamics) before and after refactoring.

---

## Review Standards

### Spec Compliance

- Each Voice's Bars match the Designer's spec: same pitches, durations and dynamics, in order.
- `pitches.length == durations.length` for every Bar.
- Bar durations add up to the TimeSignature's `beats_per_bar`, except for marked pickup or final bars.
- Each Composition defines all four `play_soprano/alto/tenor/bass` flags, and each flag gates its own `in_thread`.
- Transposition and octave offsets are applied as the spec says. `transpose` never changes its input line.
- Refactors of existing compos: the before/after bar data diff is empty.

### Style

- Use the shared library. No new pasted copies of `play_bar`, `BarStruct` or `transpose` inside compo files.
- Dynamics use the named constants (`mezzo_forte` etc.), never raw amp numbers in bar data.
- Use note symbols (`:g4`, `:r`), not MIDI numbers, in bar data.
- One `BarStruct.new(...)` per line, grouped by phrase, with a blank line between phrases (as in `men_of_erin.rb`).
- Each compo starts with a header comment giving its title, source tune, public-domain status, key, time signature and bpm.

### Security

- No `require` of gems, and no network, file-write or shell calls (`system`, backticks, `File.write`) in compos or `lib/`.
- Any file-loading path the library uses (per the ADR) must not be hard-coded to a specific user's machine in committed code.
- No copyrighted melodies or lyrics committed.

### Severity Scale

- **Low**: cosmetic issues, minor inconsistencies
- **Medium**: functional gaps, missing edge cases
- **High**: data loss, security vulnerability, spec violation

---

## Release Criteria

### Required (all must PASS)

1. [ ] `ruby -c` passes on every `.rb` file in the repo.
2. [ ] The minitest suite under `test/` passes with plain `ruby` (no gems beyond minitest).
3. [ ] `validate_bars` passes for every Voice of every changed Composition against its TimeSignature.
4. [ ] For refactored existing compos, the bar data matches the pre-refactor version exactly.
5. [ ] A human listening check in Sonic Pi on Windows is recorded: the compo plays start to finish, with each voice toggled on and off.
6. [ ] The public-domain source of each new tune is recorded in the compo header and work package.
7. [ ] Reviewer report has no open High-severity findings, and Gate 2 is approved.

### Informational (reported but non-blocking)

- Number of compos on the shared library vs. still pasting helpers
- Total bars per compo and per voice
- Duration-validation exceptions used (pickup/final bars)
- Run time of each compo at its bpm

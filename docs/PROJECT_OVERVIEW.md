# Project Overview: cewillis0011 Sonic Pi Compos

Fill this out before you create your manifest. This is a **loosely structured brief** — prose, bullets, and sketches are all fine. Your local coding agent will read this document (plus ask you follow-up questions) during L1 to generate the structured [`docs/PROJECT_MANIFEST.md`](./PROJECT_MANIFEST.template.md) that every factory agent will then consume.

---

## 1. What is this software?

One or two paragraphs answering:

- What does it do?
- Who uses it (end users, internal operators, developers)?
- What problem does it solve for them?

If this is a greenfield project, describe the vision. If it's an existing codebase, describe its current state and where you want to take it.

Begin Caroline 1

This is a repo that contains "compos" - compositions - made with the Sonic Pi framework. They are a played by the sonic pi windows desktop application. See https://sonic-pi.net/index.html .

I use them to generate part files for singers to listen to, separately or together, to sing along with when practicing their parts. Each compo is a four-part (soprano, alto, tenor, bass) arrangement of a traditional tune. I record the practice tracks with Sonic Pi's Rec button. The mix I want is "my part loud, others quiet". Solo (one part only) and full (all parts equal) are just special cases of how loud each part is.

Where I want to take it:
- The helpers (`play_bar`, `BarStruct`, `transpose`, the dynamic constants) are copy-pasted into every compo. Move them into one shared library.
- Replace the `play_soprano`/`play_alto`/... on/off flags with per-part volume levels, so setting a practice mix is a one-line change.
- Add new arrangements of public-domain tunes on top of the library.

## 2. Size, Type, Languages, Resource Constraints

- **Size**: rough scale — "prototype", "small service", "mid-size SaaS", "large monorepo"
- **Type**: web app, mobile app, backend service, CLI, library, infra-as-code, data pipeline, etc.
- **Languages / frameworks**: what's in the stack? (don't worry about being exhaustive — your agent will probe for specifics)
- **Runtime / platform**: browser, Node, Go server, Lambda, Kubernetes, iOS, etc.
- **Resource constraints**: memory / CPU / latency budgets, target platforms, regulatory or compliance requirements, team size, timeline pressures

Answers:
- Size: a small personal repo with a single maintainer. It has 5 compos and a template.
- Type: a set of music scripts plus a shared helper library.
- Languages: Ruby, written in the Sonic Pi DSL.
- Runtime: the Sonic Pi desktop app on Windows. Tests run in plain Ruby + minitest, with Sonic Pi's built-in functions stubbed out.
- Constraints:
  - no gems or external dependencies
  - public-domain tunes only
  - refactoring must not change how existing compos sound
  - recording stays manual, with the Rec button

## 3. Potential SDLC Service Integrations

Which external services is this factory likely to touch during its lifecycle? List what's probable *and* what's already set up. Examples:

- **Source control** — GitHub, GitLab, Bitbucket
- **Issue tracking** — Jira, Linear, GitHub Issues
- **CI/CD / deployment** — Vercel, Netlify, GitHub Actions, AWS (ECS, Lambda, S3), GCP, Azure, Kubernetes
- **Observability** — Sentry, DataDog, Grafana, PostHog, New Relic
- **Comms** — Slack, Discord, PagerDuty
- **Data / analytics** — BigQuery, Snowflake, Redshift
- **Auth** — Auth0, Clerk, custom

Flag which you already use vs. which you're considering.

Answers:
- Already in use: GitHub (source control), beads (`bd`, issue tracking), Gas City (`gc`, factory orchestration).
- Might add: GitHub Actions to run `ruby -c` and the tests.
- Not needed: hosting or deployment, monitoring, auth, analytics.

## 4. Open Questions / Concerns

What are you unsure about going in? Architectural uncertainty, unclear user needs, missing tooling, tech-debt hotspots. Surface it here so your agent can ask better probing questions.

- How should compos load the shared library in Sonic Pi? `run_file` and `eval_file` treat shared method definitions differently, and a hard-coded path breaks on other machines.
- How quiet should the other parts be in a "my part loud" mix, so the featured part stands out but singers can still hear the harmony around it?
- How do the tests stub Sonic Pi's built-in functions without drifting from what Sonic Pi actually does?
- How do short pickup and final bars get marked so the bar-length check allows them?
- Where do new tunes come from, and how do I confirm they're public domain?
- Should the compo folder names with spaces be renamed?

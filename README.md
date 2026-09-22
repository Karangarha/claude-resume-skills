# claude-resume-skills

Skills for Claude that turn a resume into one that survives both the applicant tracking system (ATS) and the recruiter. Two skills ship today and work as a pair:

| Skill | What it does | Version |
|---|---|---|
| [`resume-guide`](skills/resume-guide/SKILL.md) | Writes, rewrites, tailors, and reviews resumes and cover letters using a unified guide built from the Harvard MCS and NYU Tisch career-office guides, plus ATS structure rules (canonical headings, parser-safe dates and layout, keyword zones and density cap, a text-extraction verification step). | 2.0.0 |
| [`ats-beater`](skills/ats-beater/SKILL.md) | Scores a resume 0–100 the way ATS engines grade it — parsing accuracy, keyword coverage, formatting compliance, structural completeness — and returns a prioritized, point-valued fix list whose rewrites defer to `resume-guide`. | 1.0.0 |

Write with `resume-guide`, score with `ats-beater`, fix with `resume-guide`, re-score. On the first real run the pair took a one-page LaTeX resume from 71 to 95, every point measured on the compiled PDF rather than projected.

## Installing

A skill is a folder containing a `SKILL.md` (YAML frontmatter with `name` and `description`, then instructions). Claude reads the description to decide when to use it and the body once it does.

**Claude Code — one line, no clone needed** (macOS / Linux / WSL):

```bash
curl -fsSL https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.sh | bash
```

That installs both skills into `~/.claude/skills/` so they are available in every project. Variations:

```bash
# only this project (writes ./.claude/skills/ in the current directory)
curl -fsSL https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.sh | bash -s -- --project

# one skill
curl -fsSL https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.sh | bash -s -- ats-beater

# from a clone (same flags; --list shows what ships; re-run to upgrade)
git clone https://github.com/Karangarha/claude-resume-skills.git
cd claude-resume-skills && bash install.sh
```

Windows PowerShell:

```powershell
irm https://raw.githubusercontent.com/Karangarha/claude-resume-skills/main/install.ps1 | iex
# or from a clone:  .\install.ps1 [-Project] [-List] [ats-beater|resume-guide]
```

Then invoke a skill by name in Claude Code (`/ats-beater`, `/resume-guide`) or just ask — the description in each `SKILL.md` is what triggers it. If you prefer not to run a script, a skill is only a folder: copy `skills/<name>/` into `~/.claude/skills/` or your project's `.claude/skills/`.

**Claude.ai / Cowork** — paste the contents of a `SKILL.md` into a new skill (Settings → Skills), or ask Claude in a Cowork session to "propose this as a skill" with the file attached and save it from the review card.

Both skills degrade gracefully without code execution, but they are far more useful with it. For `ats-beater` install:

- `poppler-utils` (`pdftotext`, `pdffonts`, `pdftoppm`) — the parser simulation
- `pdfplumber` (Python) — glyph sizes and margins
- `pdflatex` — only if the resume source is LaTeX
- `python-docx` — only for `.docx` resumes

## Using the pair

Score a resume with no posting in hand (keyword dimension is reported as an estimate against a role baseline):

> Run my resume through the ATS check — it's the PDF attached. I'm applying to backend engineering roles as a new grad.

Score against a posting and get a ranked fix list:

> Here's a posting from Greenhouse (pasted below). Score my resume against it and tell me what to change to rank higher.

Apply the fixes in the original format and re-score:

> Apply the fixes to my `.tex`, keep my template, and re-score it.

Write or tailor from scratch:

> Rewrite my resume for this posting using the resume guide, then run the ATS check on the result.

What a score report contains: the overall score and band, the four-dimension breakdown, the portfolio spread across engine weight profiles, the raw text stream the parser saw (quoted at the trouble spots), a per-term keyword table with mention counts and zone coverage, and fixes ranked by points recovered with Before → After rewrites. Nothing is invented: a missing metric becomes a bracketed placeholder and a question, never a plausible number.

## Repository layout

```
skills/
  ats-beater/
    SKILL.md            the skill (single file; rubric, workflow, report template, knowledge base)
    evals/
      evals.json        test prompts + assertions for the skill-creator eval loop
      files/            sample inputs (a job posting; supply your own resume)
  resume-guide/
    SKILL.md
install.sh              installer for macOS / Linux / WSL (works piped from curl or from a clone)
install.ps1             installer for Windows PowerShell
CHANGELOG.md            what changed, per skill, per version
LICENSE                 MIT
```

## Adding a skill

Create `skills/<skill-name>/SKILL.md` with frontmatter:

```yaml
---
name: skill-name
description: What it does and, explicitly, when Claude should use it — the description is the trigger.
---
```

Keep the body under ~500 lines; put large reference material in `references/` and executable helpers in `scripts/` next to `SKILL.md`, and point to them from the body. Add the skill to the table above and a section to `CHANGELOG.md`. If the skill has verifiable outputs, add `evals/evals.json` in the same shape as `ats-beater`'s so it can be run through the skill-creator eval loop.

## Versioning

Each skill is versioned independently in `CHANGELOG.md` (semantic versioning: rubric or output-format changes bump the major, new rules or sources bump the minor, wording fixes bump the patch). The repository is tagged `v<major>.<minor>.<patch>` whenever a skill version changes. `ats-beater` also keeps a "Knowledge base and update log" section at the bottom of its `SKILL.md` recording every source folded into the rubric, so a new lesson or study can be reconciled against what is already there, and lines marked *(working assumption)* are the calibration choices a better source should replace.

## How the ATS scoring works, briefly

An ATS never sees the styled page. It flattens the file into a linear text stream, segments it by heading with named-entity recognition, maps skills onto a taxonomy, and stores a record; ranking runs against that record. The same resume can score 92 on one engine and 68 on another, so the rubric scores robustness across engines rather than one imaginary formula. Weights (Parsing 35 / Keyword 30 / Formatting 20 / Structural 15) sit inside the ranges observed across production engines; the density cap (mentions 1–2 full weight, 3 marginal, 4+ zero and a stuffing flag) and the three-zone rule (summary, categorized skills, experience bullets) are applied term by term on the extracted text, not the source file.

## License

MIT — see [LICENSE](LICENSE).

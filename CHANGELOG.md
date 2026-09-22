# Changelog

All notable changes to the skills in this repository. Each skill carries its own version; the repository is tagged when either one changes.

## [1.1.0] — 2026-09-22

### ats-beater 1.1.0

- New `scripts/parse_resume.py`: one call replaces the eight-to-ten separate extraction commands. Compiles `.tex` on a scratch copy, then runs pdftotext (default + layout), pdffonts, glyph-size and ink-margin measurement concurrently, and analyzes the stream — contact block, canonical headings and zones, date styles (May-aware consistency check), placeholders, line-end hyphen joins, column-reorder suspects — plus keyword scoring from `--terms terms.json` (full rubric: presence, zone multiplier, acronym pairs, home-zone terms, stuffing flag) or a pruned-by-you starting list from `--jd posting.md`. Emits JSON + digest. `.docx` gets a body/table/header/footer/text-box audit.
- Verified against the calibration resumes: keyword scores match the hand computation exactly (18.9 and 25.4 / 30); every defect found manually is flagged.
- SKILL.md step 2 now runs the script (with a raw.githubusercontent.com fetch fallback for single-file installs) and falls back to manual commands only when it cannot run.
- `manifest.txt` lists the script so the installers' last-resort path ships it.

## [1.0.1] — 2026-09-22

### Installers

- `install.sh` and `install.ps1` now fall back when the GitHub archive download is blocked: shallow `git clone`, then file-by-file download from `raw.githubusercontent.com` using `manifest.txt`. Verified on a network that allows only raw.githubusercontent.com.
- `manifest.txt` added (list every file under `skills/` when adding a skill).

## [1.0.0] — 2026-09-22

### ats-beater 1.0.0 (new)

- Scores a resume 0–100 on the four dimensions production ATS engines weigh: Parsing accuracy 35, Keyword coverage 30, Formatting compliance 20, Structural completeness 15, with keyword-first and human-screen weight profiles reported as a portfolio spread.
- Simulates the parser with `pdftotext` (default reading-order mode), measures real glyph sizes and ink margins, and quotes the stream the machine saw.
- Keyword scoring with the density cap (mentions 1–2 full weight, 3 marginal, 4+ stuffing flag), three-zone multiplier (summary / skills / experience bullet), acronym first-use pairs counted once, degree and certification terms scored in their home zone, and a role-baseline mode when no job description is supplied.
- Prioritized, point-valued fix list with Before → After rewrites that defer to `resume-guide`; projections are verified by recompiling a scratch copy.
- Knowledge base: lesson 1, "How ATS reads, maps, and scores resumes", plus calibration from scoring real LaTeX resumes (multi-row `tabular*` headings extract column-first; `[scaled]{helvet}` renders under 10 pt; hyphenated terms fuse on extraction; stacked single-row tables still form a column; `\textbullet` under OT1 yields a bitmap font).
- First test round on a real resume: 71 → 95 after the recommended fixes, all verified on the compiled PDF.

### resume-guide 2.0.0 (updated from the Harvard MCS + NYU Tisch unified guide)

- New workflow step 6: export the real file, verify the parse with `pdftotext`, run `ats-beater`, fold fixes back in.
- New "ATS structure rules" section: single column, no alignment tables beyond the two-row heading, no text boxes / icons / header-footer contact info, embedded Unicode-mapped fonts, placeholders never ship, keyword placement across three zones with a three-mention cap, verify by extraction.
- Dates: "May 2026" / "05/2026" in one month style; the guides' "05/26" and "Summer 2026" kept as discouraged alternatives.
- Professional Summary is now the default for any posting-targeted resume, students included; canonical section names listed; two-degrees Education layout with dates inline; categorized skills lines; hyphenated terms protected; contact links as readable text and never in a page header/footer.
- Font size, margins, and font count are measured on the rendered PDF, not read from the template.
- DO / DON'T lists and the final checklist extended to match; sources updated.

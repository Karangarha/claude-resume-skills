# Changelog

All notable changes to the skills in this repository. Each skill carries its own version; the repository is tagged when either one changes.

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

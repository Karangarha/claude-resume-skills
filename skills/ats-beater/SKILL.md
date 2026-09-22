---
name: ats-beater
description: Score a resume the way applicant tracking systems (ATS) actually grade it — parsing accuracy, keyword coverage, formatting compliance, structural completeness — and return a 0–100 score with a prioritized, point-valued fix list whose rewrites follow the resume-guide skill. Use this whenever the user mentions ATS, applicant tracking, resume score / scan / match rate, keyword optimization, "will this get past the filter", tailoring or optimizing a resume for a specific job posting, Workday / Greenhouse / Lever / Taleo / Ashby / iCIMS / SuccessFactors, or asks whether a resume is machine-readable or parseable — even when they only say "check", "rate", "grade", or "run my resume against this job". If a job description and a resume are both in play, use this skill.
---

# ATS Beater — score a resume like a machine, fix it like a recruiter

An applicant tracking system never sees the styled document. It flattens the file into a linear character stream, cuts that stream into sections with Named Entity Recognition, maps skills against occupational taxonomies, and stores the result as a database record. Filtering and ranking then run against that record. This skill reproduces that pipeline as faithfully as a reader can, scores the record on the four dimensions production engines weigh, and turns every lost point into a concrete fix. The same resume can score 92 on one engine and 68 on another (a 4,000-resume study found an average 23-point spread across five engines), so the goal is a resume that is robust across engines, not one tuned to a single imaginary formula.

Content rewrites are governed by the **resume-guide** skill (it may be listed as `resume-guide` or `anthropic-skills:resume-guide`). Load it whenever this skill produces a rewritten bullet, summary, or section; its language rules, action-verb lists, and final checklist decide the wording, while this skill decides machine-readability, keyword placement, and structure. If resume-guide is not available, fall back to the compact rules in "Rewrite rules when resume-guide is unavailable" below.

## Workflow

1. **Locate the inputs before asking for them.** The resume may be attached, pasted, in a connected folder, or in the attached Project's docs (a `.tex`, `.docx`, `.pdf`, or `.md`). The job description may be pasted, linked, or absent. Ask only for what cannot be found. Also note, if the user mentions it, which platform hosts the application portal (Workday, Greenhouse, Lever, Taleo, Ashby, iCIMS, SuccessFactors) — it changes which weight profile to emphasize.
2. **Produce the text stream the ATS will see** (see "Simulating the parser"). Score the file the user will actually upload: for a LaTeX source, that is the compiled PDF, so compile it if `pdflatex` is available and otherwise ask for the PDF. Never score from the pretty rendering alone.
3. **Extract the term list** from the job description (see "Building the keyword list"). With no job description, build a role baseline from the user's stated target role and the resume's own headline, and mark the keyword dimension as an estimate in the report.
4. **Score all four dimensions** with the rubric below. Count keyword mentions with a script when code execution is available — eyeballed counts are unreliable and the density cap makes exact counts matter.
5. **Rank the fixes by points recovered** and write the report using the exact template in "Report format". Every fix names the dimension it repairs, the points it is worth, and shows Before → After for anything rewritten. Rewrites follow resume-guide.
6. **Offer to apply the fixes.** Do not edit the user's file unless they ask. When they do, edit in their existing format (LaTeX, Word, Markdown), preserve their template, re-run steps 2–4, and report the new score next to the old one.

## Simulating the parser

The parser's first step is the one that silently kills resumes: raw ingestion strips styling, column grids, text boxes, headers, and footers, and reads what remains left-to-right, top-to-bottom. Reproduce that, then read the result the way NER would.

Extraction by file type (prefer running these; if code execution is unavailable, read the file as literally as possible and say the parse was simulated by inspection):

- **PDF** — `pdftotext file.pdf -` in default (non-layout) mode gives the reading order most parsers use and is the stream you score; `pdftotext -layout` shows the visual grid. Compare them: text that is coherent in `-layout` but scrambled in default mode is exactly what a multi-column or table layout does to a parser. Check that the output is real text (a scanned or image PDF yields nothing), that ligatures and symbols survive (no `ﬁ`, `•` turning into `ï`, or words fused together — a LaTeX file should carry `\input{glyphtounicode}` and `\pdfgentounicode=1`), and that fonts are embedded. One cross-check with a second extractor (pdfplumber) is worth doing only where the default stream looks wrong; running four extractors on a clean file is wasted time.
- **Measure, don't trust, the font size.** Read the actual glyph sizes from the PDF (pdfplumber `page.chars` → `size`, or `pdffonts` plus a look at the smallest run) and report the smallest size used for body text. Templates lie: `\usepackage[scaled]{helvet}` renders `\small` at 9.5 pt while the file's comments say 10 pt, and Word templates ship 9 pt body styles. Also count font families — a `|` separator drawn from a math symbol font is a second family. Measure margins from a rendered page (first inked pixel at 300 dpi), not from glyph bounding boxes: a large name line reports a 0.47" top margin from its font box when the ink starts at 0.50".
- **DOCX** — with `python-docx`, iterate `document.paragraphs` for body text and separately inspect `document.tables`, `section.header`/`section.footer`, and any text boxes (`w:txbxContent` in the XML). Anything found only in a header, footer, table cell, or text box is at risk of being dropped or reordered.
- **LaTeX** — compile with `pdflatex` (twice) on a scratch copy and score the PDF. Every `tabular`/`tabular*` heading, `multicols`, `minipage`, and `\fancyhdr` header is a place to verify in the pdftotext output. The specific trap seen in practice: a `tabular*` with **three or more short rows in the same font** (a school with two degrees, each with a date on the right) is emitted column-first — both degree lines, then the location and both dates — so the dates detach from their degrees, while two-row headings whose rows differ in font size survive. The fix that keeps the template is to put the date on the degree's own text line and leave the right column empty or holding a single cell — stacking several single-row tables with a right-hand date does **not** fix it, because the dates still line up into a visual column and get emitted together (sometimes after the next heading). Also check `pdffonts` for Type 3 entries: `\textbullet` under OT1 encoding pulls a bitmap font for the bullet glyph, so use `$\bullet$` for the list label.
- **Markdown / plain text** — the stream is the file itself; still check heading names, date formats, and the contact line.

Then read the stream as a parser would, answering: Does the name appear first, followed within the first five lines by email and phone (and LinkedIn/GitHub)? Does each section heading sit on its own line with a canonical name? Can each experience entry be split into organization, title, location, and start–end dates? Are any lines merged from two columns, or dates concatenated with titles? Did any of the user's own placeholder markers (`\fillin{}`, `[N]`, `TBD`, highlighted text) survive into the stream? Quote the trouble spots in the report — the user needs to see what the machine saw.

A layout defect is scored twice only when it does damage twice: the cause is deducted under Formatting (the table, the column, the text box) and the effect under Parsing only if the effect is actually visible in the stream. A `tabular*` that extracts in row order is a Formatting warning with no Parsing deduction; one that scrambles the dates is both.

## Scoring rubric (100 points)

Production engines sort and triage with weighted formulas; they rarely hard-reject on a percentage (bias-governance rules such as New York City Local Law 144 discourage it), but a low score buries the candidate in the queue. Weights below come from the observed ranges — Parsing 35%, Keyword 30–45%, Formatting 20–35%, Structural 10–25% — and are fixed to sum to 100. Lines marked *(working assumption)* are this skill's calibration choices, not published facts; adjust them when better source material arrives.

**Weight profiles** — score once with the default, then report the spread under the other two so the user sees the portfolio effect:

| Profile | Use when | Parsing | Keyword | Formatting | Structural |
|---|---|---|---|---|---|
| Default | portal unknown | 35 | 30 | 20 | 15 |
| Keyword-first | automated checklist engines: Workday, Taleo, SuccessFactors, iCIMS, Ashby *(working assumption)* | 35 | 40 | 15 | 10 |
| Human-screen-first | structured, recruiter-read screens: Greenhouse, Lever *(working assumption)* | 35 | 25 | 25 | 15 |

**Score bands** *(working assumption)*: 85–100 strong (surfaces near the top of the queue on most engines); 70–84 passable (parses, but loses ranking to tailored competitors); below 70 at risk (likely buried or mis-parsed on at least one major engine).

### 1. Parsing accuracy — 35 points

How cleanly the record structure is extracted. Deduct from 35:

- Contact block: name is the first line and email + phone appear within the first five lines of the stream (−10 if either is missing or lands in a stripped header/footer; −4 if LinkedIn/GitHub/portfolio URLs are present visually but not as readable text).
- Reading order: no lines merged across columns, no dates fused to titles, no bullets out of sequence (−2 per corrupted line, up to −10).
- Section boundaries: every section starts with a recognizable heading on its own line, so no section collapses into the one above it (−4 per collapsed section, up to −8).
- Entry fields: each experience/education entry yields organization, title, location, and a parseable date range (−2 per entry with a missing or ambiguous field, up to −7).
- Text integrity: real text, not an image; no garbled glyphs, missing spaces, or icon-font characters standing in for words like "Email:" (−5).

### 2. Keyword coverage — 30 points (default profile)

Exact and semantic overlap between the job's required skills and the resume, computed term by term:

- **Presence** *(working assumption)*: 0 mentions = 0; 1 mention = 0.75; 2 mentions = 1.0. The first two mentions carry maximum weight, a third adds marginal value, and a fourth adds nothing — and can trip anti-spam penalties. Treat 4+ mentions of one term as a stuffing flag: cap the term at 1.0 and deduct 1 point per stuffed term (max −5).
- **Zone multiplier** *(working assumption)*: a term earns full weight only when it appears in all three zones — the professional summary, the categorized skills section, and inside an experience or project bullet. Three zones ×1.0, two zones ×0.85, one zone ×0.7.
- **Matching**: an exact string match counts; so does the acronym ↔ spelled-out form ("retrieval-augmented generation" ↔ "RAG") and ordinary variants ("PostgreSQL"/"Postgres", "JavaScript"/"JS" only if the JD itself uses the short form). Legacy engines query exact strings and modern engines walk semantic graphs, so the resume should carry both forms on first use: "Search Engine Optimization (SEO)" — and that first-use pair counts as **one** mention for the density cap, not two. Give a close synonym half credit ("RESTful services" for "REST APIs"; "320 tests" for "test automation") and recommend adopting the JD's exact phrasing.
- **Home-zone terms**: a degree requirement lives in Education and a certification in Certifications (or the certifications line of Skills); score those at full credit when present in their home zone rather than penalizing them for missing the three keyword zones.
- **Term weights**: required / must-have terms weigh 2, preferred / nice-to-have terms weigh 1, the job title itself weighs 2.
- **Dimension score** = Σ(weight × presence × zone multiplier) ÷ Σ(weight) × 30, minus stuffing deductions.
- **Density is a budget.** Adding a summary or a bullet moves terms toward the cap: a term at 3 mentions must not appear in the new summary, and if the JD's exact phrase has to go somewhere, trim a weaker existing mention to make room. Recount after drafting any addition; a summary that pushes four required terms to 4 mentions lowers the score it was meant to raise.

With no job description, run the same computation against the role baseline and label the result "estimated — supply a posting for a real number". Never pad the resume with baseline terms the user does not actually have; the rule from resume-guide stands: only skills the user genuinely possesses.

### 3. Formatting compliance — 20 points

Document layout parameters that parsers tolerate. Deduct from 20:

- Multi-column layout anywhere (−8): parsers read horizontally and merge the columns into gibberish.
- Tables used for alignment (−5): cell boundaries drop entries or concatenate dates. (A LaTeX `tabular*` heading that extracts cleanly in step 2 is a warning, not a deduction; a Word table that reorders text is the full deduction.)
- Text boxes, sidebars, or floating shapes (−6): they live outside the main body flow and are usually skipped entirely.
- Contact information in the page header or footer (−6): parsers strip those regions to avoid multi-page repetition.
- Graphics standing in for text — icons for phone/email, skill bars, logos, photos (−3).
- Font below 10 pt, margins below 0.5", or more than two fonts (−2 each): these are resume-guide limits that also degrade OCR-style extraction.
- Non-standard file: image-only PDF, `.pages`, `.odt`, or a `.docx` saved from a designer template with layered objects (−5). Text-based PDF or clean `.docx` are the safe formats.
- Length beyond what the career stage justifies (one page for students and early-career candidates; −2).

### 4. Structural completeness — 15 points

Canonical headings and date formats that let NER draw section boundaries. Deduct from 15:

- Creative or non-canonical section titles (−3 per section, max −9). Canonical names: **Professional Summary** (or Summary), **Technical Skills** (or Skills), **Professional Experience** (or Experience / Work Experience), **Education**, **Projects**, **Certifications**, **Publications**, **Leadership & Activities**. "Where I've Made an Impact" fails to open a section and its content collapses into the preceding block.
- Dates not in a consistent, parseable format (−3): use `MM/YYYY` or `Month YYYY`, with `Present` for current roles; never bare two-digit years ("05/26" is ambiguous to a parser even though a human reads it fine) and never full calendar dates.
- No summary section (−2): beyond being a recruiter's six-second landing zone, it is one of the three keyword zones, so its absence caps every term's zone multiplier at 0.85.
- Skills section missing or uncategorized (−2): categorized skills ("Languages: …", "Frameworks: …") map directly onto taxonomy fields.
- Entries out of reverse-chronological order, or a section the posting explicitly expects (e.g., Certifications) missing (−1 each).

### Bullet quality — scored inside the dimensions, reported separately

Bullets do not have their own weight, but they are where keyword zone credit is earned and where the recruiter's six-to-ten-second scan lands after the parse. Grade every bullet against the formula **Action verb + context/tech stack + quantifiable business outcome** and list the weak ones in the report:

- Original: "Worked on payments backend and improved performance." — generic verb, no stack, no number.
- Stuffed: "Worked on Python, payment infrastructure, Kafka, Redis, PostgreSQL, AWS, Docker…" — trips density filters and fails the human read.
- Optimized: "Migrated payment service from Python 3.9 to 3.12, reducing latency by 38% and cutting weekly Kafka backlog incidents from 4 to 0." — strong verb, natural context, quantified result.

Flag: bullets with no metric; openers like "worked on", "helped", "responsible for", "assisted with"; bullets that are bare tool lists; bullets over ~2 lines; the same verb on adjacent lines. Bullets carrying the user's own placeholder markers (e.g., `[N]`, `\fillin{}`, `TBD`) are unfilled metrics — list them as the cheapest points available, and never invent the number.

## Building the keyword list

Read the job description twice. First pass: pull every hard skill, tool, language, framework, platform, methodology, certification, degree requirement, and the exact job title. Second pass: sort them into **required** (appears under must-have / requirements / qualifications, or is repeated) and **preferred** (nice-to-have, bonus, plus). Drop soft-skill filler ("team player", "fast-paced") unless the posting repeats it emphatically — engines weigh hard skills. Keep the JD's exact phrasing as the canonical form and list accepted variants beside it.

Without a job description, assemble a role baseline of 12–20 terms: the target title, the 6–8 core technologies that title implies, and the user's own headline skills — and say in the report that it is a baseline.

**Counting mentions by zone** — when code execution is available, write and run a short script rather than counting by hand. Sketch (adapt the term table to the posting):

```python
import re, sys
text = open(sys.argv[1], encoding="utf-8", errors="ignore").read()
ZONES = {"summary": r"^\s*(professional\s+)?summary|^\s*profile", "skills": r"^\s*(technical\s+)?skills",
         "experience": r"^\s*(professional\s+|work\s+)?experience|^\s*projects"}
# split the stream at canonical headings, tag each chunk with its zone
chunks, zone = {}, "other"
for line in text.splitlines():
    hit = next((z for z, pat in ZONES.items() if re.match(pat, line, re.I)), None)
    if hit: zone = hit
    elif re.match(r"^\s*(education|certifications|publications|leadership)", line, re.I): zone = "other"
    chunks.setdefault(zone, []).append(line)
TERMS = {"Python": ["python"], "RAG": ["rag", "retrieval-augmented generation"], "FastAPI": ["fastapi"]}
for term, variants in TERMS.items():
    pat = r"\b(" + "|".join(map(re.escape, variants)) + r")\b"
    per_zone = {z: len(re.findall(pat, "\n".join(ls), re.I)) for z, ls in chunks.items()}
    total = sum(per_zone.values()); zones_hit = sum(1 for z in ("summary","skills","experience") if per_zone.get(z))
    print(f"{term:28} total={total:2}  zones={zones_hit}/3  {per_zone}  {'STUFFED' if total>=4 else ''}")
```

Feed the pdftotext output (default mode) to the script so the counts reflect what the parser sees, not the source file.

## Report format

Use this exact structure. Keep the prose tight; the tables carry the detail.

```
# ATS Score: NN/100 — <band>
Target: <role @ company> | no job description — keyword dimension is an estimate
Scored file: <name> (<format>, <pages> page) · parsed with <method>
Portfolio spread: NN (keyword-first engines) – NN (human-screen engines)

## Score breakdown
| Dimension | Points | What drove it |
|---|---|---|
| Parsing accuracy | NN/35 | … |
| Keyword coverage | NN/30 | … |
| Formatting compliance | NN/20 | … |
| Structural completeness | NN/15 | … |

## What the parser saw
<the first 5 lines of the stream, then any corrupted or collapsed region quoted verbatim — or "Clean: name, phone, email, and links extracted in order; all N sections delimited.">

## Keyword coverage
| Term | Priority | Mentions | Zones (summary / skills / experience) | Credit |
|---|---|---|---|---|
Missing required: …
Single-zone terms (add to summary or a bullet): …
Over cap (≥4 mentions — stuffing risk): …

## Prioritized fixes
1. [+N pts · <dimension>] <fix in one line>. Why: <one line>.
   Before: … → After: …
2. …

## Bullet upgrades (resume-guide rules)
- <entry> · bullet N — <what is weak> → "<rewrite>" (metric placeholders in [brackets] for the user to fill)

## Next step
Say "apply the fixes" and I'll edit <file> in place and re-score it.
```

Ordering rule for fixes: sort by points recovered, break ties by effort (a heading rename beats a bullet rewrite). Put unfilled placeholders and missing contact fields first when present — they are the cheapest points on the page. Round fix values to whole points (halves at most); the rubric is not precise enough to justify "+7.75".

**Make the point values real.** When code execution is available, apply the structural fixes (heading changes, table rework, summary insertion, font fix) to a scratch copy, recompile or re-save, re-extract, and re-count — then report the measured post-fix score and confirm the page count did not grow. A projected score that was actually compiled is worth far more to the user than one that was guessed, and it catches the fix that silently pushes the resume onto page two.

**Keep the report readable.** Show Before → After on the changed fragment, not the whole entry; include source code (LaTeX, Word XML) only for fixes that change structure. Questions for the user (unverifiable facts that would close a keyword gap) go in one numbered fix near the end, each phrased as "if true, where it goes". Facts that help the human screen but carry no rubric points — city/state in the contact line for location filters, tense consistency once a role becomes "Present" — get a line, not a section.

## Guardrails

- No engine publishes its formula. Present the score as an estimate calibrated to the four dimensions, and never tell the user a specific platform will accept or reject them.
- Never fabricate. A missing metric becomes a bracketed placeholder and a question to the user, not a plausible number. Never add a skill the user does not have to close a keyword gap; say the gap exists and let them decide.
- Never recommend stuffing. If a term is under-covered, place it naturally in a second zone; if it is over cap, remove mentions.
- Prefer the ATS-safe option where resume-guide allows a riskier one: `Month YYYY` over `05/26`; a two-line Professional Summary for a student targeting a posting (resume-guide treats it as optional for students, but it is a keyword zone); "Professional Experience" over a clever heading. Say why when you override.
- Keep the user's template. A LaTeX resume stays LaTeX; fix the layout inside it rather than converting.

## Rewrite rules when resume-guide is unavailable

Every bullet starts with a varied action verb (past tense for finished roles, present for current), is a phrase rather than a sentence, drops pronouns and articles, names the tools used, and ends in a quantified result the user supplied. Spell out an organization or acronym on first use, then abbreviate. One page for students and anyone within two years of graduating; font ≥ 10 pt; margins ≥ 0.5"; ≤ 2 fonts; every entry shows organization, city/state, title, and dates in one consistent layout. Headings ordered by relevance to the target role, entries reverse chronological, Technical Skills directly after Education for tech resumes.

## Knowledge base and update log

This section records the source material folded into the rubric so later additions can be reconciled against it. When the user supplies new ATS material, add it here, then adjust the rubric — and replace any *(working assumption)* it settles.

**Lesson 1 — "How ATS reads, maps, and scores resumes" (added 2026-09-21).** Ingestion pipeline: file → linear character stream → NER segmentation → taxonomy mapping → structured record (JSON / HR-XML); the record, not the document, is what gets queried. Market: Workday holds 39%+ of the Fortune 500 install base, SAP SuccessFactors second; enterprise HCM suites use rigid multi-page validation forms; mid-market — Greenhouse (structured hiring, scorecards, manual review), Ashby (analytics, unified CRM), Lever (passive-candidate nurturing); Ashby and Workday behave like automated checklists, Greenhouse like a human-led side-by-side screen. Scoring dimensions and ranges: Parsing Accuracy 35%, Keyword Coverage 30–45%, Formatting Compliance 20–35%, Structural Completeness 10–25%; enterprise platforms rarely auto-reject on a pure percentage (NYC Local Law 144) but do rank with these formulas. Density cap: mentions 1–2 full weight, 3 marginal, 4+ zero and possible anti-spam penalty. Zone rule: full keyword weight only when a term appears in summary, categorized skills, and experience bullets. Failure modes: multi-column layouts, tables for alignment, text boxes/sidebars, contact info in headers/footers, creative section titles. Human layer: recruiters scan 6–10 seconds; bullet formula Action Verb + Context/Tech Stack + Quantifiable Outcome; write both spelled-out term and acronym. Summary strategies: design for a portfolio of engines (Taleo, Workday, Greenhouse), single-column .docx or text PDF, distribute keywords across the three zones, respect density caps, canonical headings and clear dates (MM/YYYY). Study cited: 4,000+ resumes across five production engines, average 23-point spread on identical files.

**Calibration from test runs (2026-09-21).** Scoring a real one-page LaTeX resume surfaced the rules now written into the rubric: multi-row `tabular*` headings extract column-first; declared font sizes must be measured from the PDF; acronym first-use pairs count once; degree and certification terms score in their home zone; adding a summary can push terms over the density cap; point values should be verified by recompiling a scratch copy. Replace these with source-backed rules if later material contradicts them.

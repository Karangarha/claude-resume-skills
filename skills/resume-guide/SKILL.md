---
name: "resume-guide"
description: "Write, rewrite, tailor, or review a resume or cover letter using a unified best-of-both guide built from the Harvard MCS and NYU Tisch career-office guides — structure, language rules, formatting limits, action verbs, do/don't lists, FAQs, cover-letter format, review checklist — plus the ATS structure rules (canonical headings, parser-safe dates and layout, keyword zones and density cap, a pdftotext verification step) learned from scoring real resumes. Use for any resume or cover-letter drafting, editing, tailoring, or critique, even a single bullet."
---

# Resume & Cover Letter Guide

Use this skill whenever the user asks to draft, rewrite, tighten, tailor, or critique a resume, a resume bullet, or a cover letter. It is one unified guide that combines everything in the Harvard College Guide to Creating a Strong Resume (Mignone Center for Career Success) and the NYU Tisch Office of Career Development Resume Guidelines & Samples into a single set of rules, templates, verb lists, and checks, with an added layer of applicant-tracking-system (ATS) structure rules — because the first reader of almost every resume is a parser that flattens the file into a text stream, and the career-office guides were written for the human who reads it second. Where the two layers disagree, the parser-safe choice wins and the section "ATS structure rules" says why.

The companion **ats-beater** skill scores a finished resume the way an ATS does; this skill writes it. Use both: write here, score there, fix here.

## Workflow

1. **Gather inputs.** Get the current resume — or a master list of every job, internship, activity, project, and award with dates — plus the target role or job description and any missing facts: dates, locations, metrics, tools, team sizes. Never invent experience, numbers, employers, or credentials; quantify only with figures the user supplies or confirms. If a section is thin, ask for specifics rather than padding.
2. **Choose the format.** Reverse chronological by default. Use a functional/combination layout only when the user has no experience in the target field and needs to foreground transferable skills.
3. **Tailor.** Not every experience must relate directly, but the resume must reflect the skills the employer values. Pull keywords from the job description into every relevant entry; order sections and bullets by relevance to that description; keep one master list and produce a tailored version per application. Place each key skill in three zones — summary, skills line, and one bullet — and stop at three mentions (see "Keyword placement").
4. **Draft or revise** using the rules below. Preserve the user's existing template/format (LaTeX, Word, Markdown) unless asked to change it.
5. **Self-review** against the final checklist before returning anything, and tell the user to read it aloud and get a second reader.
6. **Export and verify the parse.** Compile or export the file the user will actually upload (for LaTeX that is the compiled PDF) and, when code execution is available, run `pdftotext file.pdf -` in default mode and read the stream: name first, email and phone within five lines, every heading on its own line, every date next to its entry, no fused words, no leftover placeholders. Then run the `ats-beater` skill on that PDF if it is available and fold its fixes back in before returning. A layout that only looks right is not finished.

## Purpose, format, and length

- A resume is a concise, informative summary of your abilities, accomplishments, education, and experience. Its one job is to persuade the employer to interview you: highlight your strongest assets and skills and differentiate yourself from other candidates seeking similar positions.
- **Reverse chronological** (most recent first within every section) is the standard format and the right choice whenever recent work and education match the target role. **Functional / combination** highlights transferable skills under skill headings and is reserved for candidates without experience in their chosen field.
- **One page** for students and anyone within about two years of graduating, and for most fields generally. Two pages only with a great deal of relevant experience; if two, repeat the name at the top of page 2.
- Fit content by editing, never by shrinking: font **no smaller than 10 pt**, margins **no narrower than 0.5"** on every side, **no more than two fonts** — all three **measured on the rendered PDF**, not read off the template. Templates lie: `\usepackage[scaled]{helvet}` renders `\small` at 9.5 pt while its comments say 10 pt, and Word templates ship 9 pt body styles. Measure glyph sizes with `pdfplumber` (`page.chars` → `size`) and margins from the first inked pixel of a 300 dpi render — a large name line reports a 0.47" top margin from its font box when the ink starts at 0.50".
- Resume conventions vary by country; for international applications, flag that local norms (photo, personal details, length) may differ.

## Language rules

Resume language is specific rather than general; active rather than passive; written to express, not impress; articulate rather than "flowery"; fact-based (quantify and qualify); and written for people — and applicant-tracking systems — that scan quickly.

Every description line:

- Starts with an action verb. Past tense for finished roles, present tense for current ones. Never lead with "Duties" or "Responsibilities."
- Is a phrase, not a sentence. No first person or pronouns (I, we, my); drop articles (a, an, the) so phrases flow.
- States what was done, the skills used, and the **result or accomplishment**. Quantify wherever a real number exists: head counts, dollars, percentages, data points, hours per week, users, performance gains, rankings, budgets.
- Puts the most relevant or important task first within each position.
- Uses a different verb from neighboring lines.
- Is consistent about numbers (numerals or words, never both), tense, and punctuation.
- Uses professional, concrete wording — no slang, colloquialisms, or casual language ("kids", "took care of", "helped out", "watched"); no creative section names ("My Related Job Skills Matching Your Needs").
- Spells out an organization or acronym the first time and abbreviates after — "New York Musical Theatre Festival (NYMF)" — because "BMI" could be body mass index or a music publisher. The same rule serves the parser: legacy engines match exact strings and modern ones match meaning, so "Search Engine Optimization (SEO)" satisfies both, and the first-use pair counts as one mention toward the density cap, not two. Never abbreviate ordinary words ("w/").
- Keeps hyphenated compound terms on one line. A line-end break turns "metadata-regex" into "metadataregex" and "text-to-Cypher" into "textto-Cypher" after PDF text extraction; protect them (`\mbox{metadata-regex}` in LaTeX, a non-breaking hyphen in Word) or rephrase.

Six or seven lines is enough for a relevant position; summarize less-relevant jobs in one or two lines (or one line each under "Additional Experience"). Never add positions or activities just to fill space.

**Bullet patterns to imitate (structure, not content):**

- "Managed focus groups and consumer surveys gathering over 500 data points. Presented findings to senior managers using quantitative analysis and creative visuals."
- "Implemented new web site, including back end database storage system and dynamic web pages."
- "Organized marketing and advertising campaign using Mailchimp, resulting in 20% increase in membership. Coordinated tech conference and networking reception for 30 professionals and 75 students."
- "Developed training program for 25 charity runners. Raised over $25,000 to support …"
- "Analyze data using Python to determine trends in service usage." (current role, present tense)
- "Advised artists on performance and repertoire, resulting in three major label signings."
- "Tour managed three album tours … all 20–25% under budget."
- "Increased revenues from an average $100,000 to over $2 million, and profit on live shows from 52% to 99%."
- "Managed activities across over 30 sports and clubs, scheduled and approved all fundraisers."

## Formatting and consistency rules

- One layout for every entry (below); identical fonts, spacing, bold/italic/underline use, capitalization, and alignment throughout. Don't center one section and left-align the next; don't bold or italicize one date when the others aren't.
- Abbreviate every state the same way ("CA" everywhere, or "California" everywhere).
- Dates as "May 2026" or "05/2026", with "Present" for current roles, and **one month style across the whole page** — "Jun" everywhere or "June" everywhere, never "Sept". The career guides also accept "05/26" and "Summer 2026" (capitalize seasons); prefer month-and-year because a bare two-digit year is ambiguous to a parser and a season has no month at all. Never full calendar dates like 4/17/2026; never start a line with a date.
- Capitalize degrees and majors ("Bachelor of Fine Arts", "Dramatic Writing").
- Balance white space so the page is easy to read and skim.
- Bullets or short paragraphs — pick one style and keep it across the whole document.
- Check that the layout survives conversion to PDF — concretely, by extracting the text back out (workflow step 6) rather than by looking at it; keep resume and cover letter in the same font type and size.
- Build the layout in a fresh document you control; premade templates are easy to create but hard to edit. If you like a resume's look, model its aesthetics in your own file.

**Entry layout — identical for every position, activity, or project:**

```
Organization (bold)                                  City, State (or Remote)
Position Title (bold)                                Month Year – Month Year
• Action-verb phrase with details and quantified result
• …
```

Every entry needs all four: organization name, city and state (city and state only), title, and dates. A title with no employer ("Camp Counselor WY 2010") is an error.

The right-aligned column is safe for a two-row heading (organization/location, title/dates): a parser emits the left column then the right, but both land inside the same entry. It is **not** safe for three or more short rows in the same font — a school with two degrees, each with a date on the right — where the dates come out after all the degree lines (sometimes after the next heading) and detach from their degrees. Stacking single-row tables does not fix it, because the dates still line up into a visual column. For that case put the date on the degree's own line and keep only the location on the right of the organization row:

```
Kean University                                      Union, NJ
M.S. in Computer Science, Expected May 2027
B.S. in Computer Science, May 2026 — Minor in Cybersecurity — GPA: 3.7 — Dean's List (5 semesters)
```

## Sections and their rules

**Header**

- Name on its own line (first name first, middle name/initial optional, last name last). Then one line: `Street Address • City, State Zip • email • phone` (local and/or permanent address; the number you actually answer). Missing email or phone is one of the five most common mistakes.
- Use a school or personal email you check regularly — never a current employer's address, never an unprofessional handle. A portfolio, website, or GitHub link belongs here, written out as readable text (`github.com/handle`), never as an icon or a bare "Portfolio" hyperlink — the parser keeps the text and drops the link.
- Keep the whole block in the page body. Contact details placed in a Word/LaTeX page header or footer are stripped by parsers (they discard those regions to avoid repeating them on every page), which is the most common way a resume arrives with no phone number.
- No photo (performer/actor resumes are the only exception), no age, gender, or references.

**Section order** — headings in order of importance to the target role; within each heading, reverse chronological. Default for students and early-career candidates:

1. Education
2. Technical Skills — placed immediately after Education for tech / computer-science resumes
3. Experience
4. Leadership & Activities — move above Experience when it is more relevant to the opportunity
5. Skills & Interests (optional)

Experienced candidates may move Education to the end and open with a **Profile / Summary of Qualifications**: 2–4 lines naming the target role, years/scope of experience, and core competencies ("Aspiring creative cinematographer with a solid background in camera operations and lighting design. Familiar with … Proficient in …"). An **Objective** is optional; if used, name a specific position (never "a challenging career opportunity"), and drop it when a cover letter accompanies the resume.

For any resume aimed at a posting — students included — add a 2–3 line **Professional Summary** directly under the contact block, before Education. The career guides treat it as optional for early-career candidates, but it is one of the three zones an ATS credits for keyword placement (without it every term is capped) and the only natural place the target job title appears; recruiters also land there in their six-second scan. Write it in phrases, not sentences, naming the role, the degree and date, and the four to six competencies the posting asks for — using only terms that are not already at three mentions elsewhere.

**Use canonical section names** so the parser can open and close each block: Professional Summary (or Summary), Education, Technical Skills (or Skills), Experience / Professional Experience / Work Experience, Projects, Certifications, Publications, Leadership & Activities, Honors & Awards. A heading the parser does not recognize ("Where I've Made an Impact") never starts a section, and everything under it collapses into the block above.

**Education**

- Institution — City, State — graduation or expected graduation date. Include school/division, degree, all majors, minors, and concentrations. Two degrees at one school: one line per degree with its date on that line (see the entry-layout note above), honors folded into the degree line ("Dean's List (5 semesters)") rather than a separate bullet.
- GPA: include it when it is 3.5 or higher, when the employer asks for it, or when the field expects it (3.0+ is the floor for listing). Say if it is weighted; it may be separated by program.
- Thesis (optional). Honors, scholarships, and awards — including from community or civic organizations — go here or in a separate Honors section.
- Relevant Coursework (optional): only courses relevant to the position, including ones outside the major; favor electives and upper-level courses that set the candidate apart.
- Study abroad, if applicable: `Institution — City, Country — dates` + "Study abroad coursework in ____."
- High school: include for freshmen and early-career candidates (high-school organizations show leadership and interests); name, city/state, graduation date, and optionally GPA, SAT/ACT scores, or academic honors an employer may want. If an employer asks for standardized scores or GPA, they go in this section.
- Substantial time commitments can be noted (e.g., "Commit 25 hours per week to Varsity Field Hockey Program").
- Combined-degree wording (adapt to the school): "A.B. in Biomedical Engineering with a joint concentration in Computer Science"; "A.B. in History with a double concentration in Statistics"; "A.B./S.M. Computer Science, GPA 3.6"; "A.B./S.M. Computer Science; Concurrent S.M. Computer Science"; "Concurrent Degrees: S.M. Computer Science; A.B. Applied Mathematics".

**Experience**

- Paid employment, internships, volunteer work, military service, and unpaid roles with substantial hours all belong here. Campus and volunteer activities demonstrate relevant skills just as employment does; if the bulk of your experience came from an activity, list it under Experience and describe it fully.
- Describe responsibilities and skills used, and emphasize results and accomplishments, following the language rules above.
- When unrelated jobs would dilute the section, split into "Relevant Experience" (or "Industry Experience") and "Additional Experience" (one line each). Subsections are distracting if only one position falls under each.

**Leadership & Activities** — clubs, student government, community service, athletic teams; emphasize leadership duties. Same entry layout as Experience, or omit descriptions for minor activities.

**Optional category headings** — use when relevant; if one holds significant experience, make it the primary Experience section: Leadership Experience, Public Service Experience, Technical Skills, Research Experience (add a "Project: …" line under the title), Performing Arts Experience, Activities (one-line entries: "Member. Collaborate on social and community service activities."), Selected Projects / Credits, Honors & Awards, Accomplishments, Publications / Exhibitions. Creative candidates may also point to portfolios and websites.

**Skills**

- Technical: software, programming languages, tools, operating systems — each with an honest level of fluency: "Advanced knowledge of: …" / "Working knowledge of: …", or "familiar with / knowledge of / experience in", or inline ("SQL, R (intermediate), SPSS (beginner)"). Include skills even below full proficiency, labeled honestly. Computer Skills and Languages may be separate categories.
- Categorize the technical list with labeled lines ("Languages: …", "Frameworks: …", "Databases: …", "Tools & Platforms: …", "Concepts: …"); the labels map onto the parser's taxonomy fields, and an uncategorized comma list does not. A certification line fits here or in its own Certifications section — either parses. Drop beginner certificates that undersell the degree ("Python Essential Training" on a graduate CS resume); each one also spends a mention of its keyword.
- Language: foreign languages and fluency.
- Laboratory: lab techniques and tools, if applicable.
- Concrete measures strengthen a skills line ("Typing speed: 56 words per minute", certifications, licenses).
- Never a list of unrelated tasks and adjectives ("Answering phones, driving, Knitting, Baking, Detail-oriented. Friendly.").

**Interests** (optional) — adds a personal dimension and can spark interview conversation. Be specific; about three; relevant to the role; travel counts. Drop it first when space is needed for related experience.

**References** — never on the resume. "References available on request" is optional and the first thing to cut; provide references (past employers, current or past professors, volunteer coordinators) on a separate document.

## Page skeleton

```
                              Firstname Lastname
  Street Address • City, State Zip • youremail@school.edu • phone number

                                  Education
University Name                                              City, State
Degree, Major/Concentration. GPA [if 3.5+ or requested]      Graduation Date
Thesis [optional]
Relevant Coursework: [optional; honors and awards may also go here]

Study Abroad Institution [if applicable]                     City, Country
Study abroad coursework in _____.                            Month Year – Month Year

High School Name [early-career only]                         City, State
[GPA, SAT/ACT, or academic honors if wanted]                 Graduation Date

                          Technical Skills [tech resumes]
Programming: … | Frameworks/Tools: … | Operating Systems: …

                                  Experience
Organization                                                 City, State (or Remote)
Position Title                                               Month Year – Month Year
• Most recent position first; action verb + details + quantified outcome
• Different verb; skills, knowledge, abilities, or achievements the reader should see
• Quantify where possible; phrase not sentence; no pronouns; no articles

Organization                                                 City, State
Position Title                                               Month Year – Month Year
• Next-most-recent position, same rules

                            Leadership & Activities
Organization                                                 City, State
Role                                                         Month Year – Month Year
• Same format as Experience, or omit descriptions for minor activities

                          Skills & Interests [optional]
Technical: software and languages with fluency level
Language: languages with fluency level
Laboratory: techniques/tools [if applicable]
Interests: about three specific, relevant activities
```

The same skeleton works in paragraph style: replace each bullet group with a 2–4 line paragraph of action-verb phrases, articles dropped.

## Format variants

- **Reverse chronological (default):** as above. Bold or ALL-CAPS organization/title, location and dates right-aligned, 2–5 bullets per entry.
- **Profile-led (experienced):** Profile / Summary of Qualifications, then Experience, Selected Projects / Credits, Additional Work Experience (one line each), Technical Skills tiered by proficiency, Awards, Education last.
- **Functional / combination:** Objective, then experience grouped under skill headings ("Management", "Administration") or, within each position, sub-labels ("Program Development", "Research", "Leadership", "Grant Writing") with bullets beneath; Education, Honors, Related Courses, and Skills follow. Only when chronology would hide the transferable skills.
- **No internships yet:** Education first (with high-school honors if early), then "Selected Leadership Experience" built from campus or high-school roles with quantified bullets ("assembly with 12 performing groups", "budget for over 10 restaurants", "student body of 2100"), Honors & Awards, Skills.
- **Creative / credit-based fields:** tabular credits (Project / Director / Producer), year-led lists (Exhibitions, Awards, Residencies, Affiliations), or a Works section before Work Experience.

## ATS structure rules

The parser strips styling, columns, text boxes, headers, and footers, reads what is left top-to-bottom, cuts it into sections by heading, and stores fields — the recruiter searches that record, not the page. Everything below exists to keep the record intact.

- **One column.** Parsers read across the page, so a two-column layout interleaves unrelated text. Sidebars and text boxes sit outside the body flow and are usually skipped entirely.
- **No tables for alignment beyond the two-row heading.** Word tables drop cells and concatenate dates; LaTeX `tabular*` headings are fine only while the extracted stream keeps each date beside its entry — verify, and never stack three or more short rows.
- **No graphics standing in for text**: icon fonts for phone/email, skill bars, logos. If it is not text, it is not in the record.
- **Text-based PDF or clean .docx**, embedded Type 1/TrueType fonts with Unicode maps (`pdffonts` shows `uni yes`, no `Type 3` rows; in OT1 LaTeX use `$\bullet$`, since `\textbullet` pulls a bitmap font), `\input{glyphtounicode}` + `\pdfgentounicode=1` in pdfLaTeX. An image-only PDF yields an empty record.
- **Placeholders never ship.** `[N]`, `\fillin{…}`, `TBD`, highlighted text reach the parser as literal words and make a date field unreadable; fill the value or cut the line before exporting.
- **Keyword placement** — each skill the posting requires appears in three zones: the summary, the categorized skills line, and inside one experience or project bullet. The first two mentions carry full weight, a third adds little, and a fourth adds nothing and can trip anti-spam filters. Count on the extracted text, not the source: a project heading's stack line ("React, React Three Fiber, …") counts every token, and the same stack repeated across three projects is the usual cause of a stuffing flag. Adding a summary spends mentions, so recount after writing it and keep terms already at three out of it.
- **Verify by extraction**, not by eye: `pdftotext file.pdf -` (default mode) is close to what parsers see; `pdftotext -layout` is what humans see. Text that is coherent in the second and scrambled in the first is a layout defect.

## DO

- Proofread for clarity, grammar, and spelling; have others proofread; read it aloud.
- Be consistent in format and content: spacing, underlining, italics, bold, capitalization, state abbreviations, date style, alignment.
- Make it easy to read and skim; balance white space.
- List headings in order of importance; within headings, most recent first.
- Keep a master list of every activity and job with dates, and build a tailored resume from it for each opportunity.
- Include keywords from the position description in every relevant entry, in the posting's exact phrasing, spread across summary, skills, and bullets, and capped at three mentions each; rank descriptions by relevance to the job.
- Use canonical section headings, month-and-year dates in one style, and a Professional Summary whenever the resume targets a posting.
- Keep skills and interests relevant to the position.
- Avoid information gaps such as a missing summer.
- If starting from scratch: list everything you've ever done, add dates, write a description for each, then order most recent first.
- Confirm formatting survives PDF conversion; use the same font type and size on the cover letter.

## DON'T

- Use personal pronouns or first person, or a narrative style.
- Use slang, colloquialisms, casual language, or "flowery" wording.
- Be vague, or abbreviate organization names without spelling them out first.
- Include a picture (except performer resumes), age, gender, or references.
- Start a line with a date, or list full calendar dates.
- Go below 10 pt, below 0.5" margins, or above two fonts.
- Use a workplace email or an unprofessional one.
- Add positions or activities just to fill space.
- Lie or exaggerate — and never fabricate on the user's behalf.
- Use multi-column layouts, sidebars, text boxes, alignment tables of three or more rows, icon fonts, or contact details in a page header or footer.
- Repeat a keyword past three mentions, ship placeholder text, or leave a bare two-digit year or a mixed month style ("June" beside "Sept") on the page.

## Action verbs

Choose the verb that matches what the line demonstrates; vary verbs across adjacent lines. (Past tense shown; use present tense for current roles.)

- **Leadership & Management:** Accelerated, Accomplished, Achieved, Acquired, Activated, Adapted, Administered, Amended, Analyzed, Anticipated, Arbitrated, Assigned, Attained, Authorized, Automated, Awarded, Balanced, Budgeted, Chaired, Consolidated, Contracted, Controlled, Coordinated, Counseled, Delegated, Demonstrated, Developed, Directed, Drafted, Earned, Effected, Elected, Encouraged, Engineered, Evaluated, Exceeded, Executed, Explained, Facilitated, Governed, Guided, Handled, Headed, Hired, Impacted, Implemented, Improved, Inaugurated, Increased, Innovated, Inspired, Instigated, Instituted, Instructed, Issued, Led, Managed, Mastered, Motivated, Negotiated, Nurtured, Operated, Orchestrated, Organized, Oriented, Oversaw, Performed, Pioneered, Planned, Predicted, Presented, Presided, Prioritized, Produced, Programmed, Prompted, Proved, Re-negotiated, Recommended, Reconciled, Recruited, Rectified, Reduced, Regulated, Reorganized, Represented, Reviewed, Scheduled, Settled, Solved, Spearheaded, Strengthened, Supervised, Supported, Surpassed, Taught, Trained
- **Communication:** Addressed, Advised, Amended, Anticipated, Arbitrated, Arranged, Assumed, Attracted, Authored, Authorized, Budgeted, Calculated, Challenged, Clarified, Co-authored, Collaborated, Conceptualized, Contacted, Contributed, Convinced, Corresponded, Decentralized, Delegated, Delivered, Developed, Directed, Documented, Drafted, Earned, Edited, Encouraged, Energized, Enlisted, Explained, Exposed, Formulated, Illuminated, Influenced, Informed, Instructed, Interpreted, Interviewed, Lectured, Liaised, Mediated, Moderated, Motivated, Negotiated, Offered, Persuaded, Presented, Promoted, Proposed, Proved, Publicized, Published, Re-negotiated, Recommended, Reconciled, Recruited, Reported, Rewrote, Sold, Spoke, Suggested, Summarized, Synthesized, Taught, Translated, Verbalized, Wrote
- **Research & Analysis:** Administered, Appraised, Approved, Arbitrated, Assessed, Audited, Augmented, Authorized, Awarded, Budgeted, Calculated, Challenged, Clarified, Collected, Composed, Computed, Concluded, Conducted, Constructed, Critiqued, Defined, Derived, Determined, Diagnosed, Discovered, Eliminated, Estimated, Evaluated, Examined, Extracted, Forecasted, Formalized, Formed, Identified, Illuminated, Inspected, Interpreted, Interviewed, Investigated, Isolated, Modeled, Organized, Perceived, Pinpointed, Prevented, Programmed, Regulated, Reorganized, Resolved, Revamped, Reviewed, Revised, Simplified, Specified, Standardized, Summarized, Surveyed, Systematized, Tested, Traced
- **Technical & Building:** Accomplished, Achieved, Acquired, Amplified, Arranged, Assembled, Attained, Augmented, Authored, Automated, Broadened, Built, Calculated, Composed, Computed, Conceived, Conceptualized, Constructed, Contributed, Cultivated, Designed, Developed, Devised, Diagrammed, Documented, Drafted, Engineered, Established, Fabricated, Facilitated, Formalized, Formed, Formulated, Generated, Improved, Increased, Innovated, Installed, Invented, Launched, Maintained, Obtained, Operated, Optimized, Overhauled, Programmed, Recorded, Remodeled, Repaired, Restored, Shaped, Solved, Specified, Staged, Standardized, Streamlined, Structured, Upgraded
- **Creative & Initiative:** Accomplished, Acted, Activated, Affected, Anticipated, Attained, Automated, Bought, Broadened, Changed, Collected, Composed, Conceived, Conceptualized, Controlled, Converted, Created, Customized, Designed, Developed, Devised, Directed, Drafted, Elected, Engineered, Established, Exposed, Facilitated, Fashioned, Formed, Formulated, Founded, Gathered, Identified, Illuminated, Illustrated, Implemented, Improvised, Initiated, Innovated, Inspired, Instigated, Instilled, Instituted, Integrated, Introduced, Invented, Launched, Obtained, Originated, Performed, Pioneered, Planned, Presided, Promoted, Proposed, Published, Redesigned, Regained, Revised, Revitalized, Shaped, Stimulated, Visualized
- **Quantitative & Planning:** Administered, Allocated, Analyzed, Appraised, Assessed, Audited, Authored, Balanced, Broadened, Budgeted, Calculated, Collected, Compiled, Composed, Computed, Conceptualized, Constructed, Designed, Developed, Devised, Discovered, Drafted, Estimated, Evaluated, Forecasted, Found, Gathered, Generated, Identified, Instilled, Insured, Investigated, Located, Managed, Marketed, Maximized, Minimized, Modified, Planned, Prevented, Programmed, Projected, Researched, Reviewed, Scheduled, Streamlined, Studied
- **Teaching, Helping & Teamwork:** Accomplished, Adapted, Advised, Assessed, Assisted, Attracted, Balanced, Clarified, Co-authored, Coached, Collaborated, Communicated, Contributed, Coordinated, Counseled, Cultivated, Decentralized, Demonstrated, Demystified, Developed, Diagnosed, Directed, Educated, Enabled, Encouraged, Enhanced, Evaluated, Expedited, Explained, Facilitated, Familiarized, Guided, Informed, Instructed, Motivated, Negotiated, Nurtured, Operated, Participated, Performed, Persuaded, Proposed, Provided, Re-negotiated, Reconciled, Referred, Rehabilitated, Related, Represented, Scheduled, Served, Serviced, Set Goals, Stimulated, Strengthened, Studied, Supported, Taught, Trained
- **Organizational:** Accelerated, Added, Administered, Allocated, Approved, Arranged, Augmented, Awarded, Balanced, Broadened, Budgeted, Captured, Cataloged, Centralized, Changed, Charted, Classified, Collected, Combined, Compiled, Completed, Composed, Condensed, Consolidated, Constructed, Controlled, Converted, Corrected, Decentralized, Defined, Determined, Diagrammed, Dispatched, Distributed, Documented, Elected, Eliminated, Engineered, Executed, Expanded, Extracted, Formalized, Framed, Gained, Gathered, Generated, Implemented, Inspected, Isolated, Launched, Localized, Managed, Modernized, Monitored, Operated, Organized, Planned, Prepared, Processed, Programmed, Purchased, Recorded, Reduced, Refined, Regulated, Reinforced, Reorganized, Replaced, Restructured, Retrieved, Screened, Selected, Shaped, Simplified, Sold, Specified, Staged, Steered, Streamlined, Structured, Systematized, Tabulated, Tightened, Unified, Updated, Utilized, Validated, Verified

## Role of AI (you) in this process

The resume and cover letter must authentically represent the user. Generative AI is a useful editor — brainstorming revisions to bullet points, incorporating keywords gleaned from the job description, strengthening what already exists — but must not be the primary author, because its output is generic. Every line should be specific to this person, drawn from facts they supplied, with nothing exaggerated.

## Cover letters

A cover letter is a writing sample and part of the screening process. It articulates why the user fits this particular role, highlights the skills and experiences most applicable to the job or industry, and is tailored to the specific organization. One page, same font type and size as the resume.

**Format:**

```
Date

Contact Name
Contact Title                (complete title and address; this block is
Company Name                  optional if space is tight)
Street Address
City, State Zip

Dear <Specific Person>:      (a particular person whenever possible; use a colon)

Opening paragraph — clearly state why you're writing, name the position or type
of work you're exploring and, where applicable, how you heard about it. A summary
statement giving three reasons you'd be a good fit works well here.

Middle paragraph(s) — explain why you are interested in this employer and this
type of work. Point out relevant school or work experience with one or two key
examples and concrete results; do not reiterate the entire resume. Emphasize
skills that relate to the job, confidently — the reader treats this as a sample
of your writing. Make them want to read the resume: brief but specific.

Closing paragraph — reiterate your interest and enthusiasm for contributing to
the organization's work, thank the reader for their consideration, and end by
stating that you look forward to discussing the position further. Remind them
what you can do for the organization.

Sincerely,

Name
```

**Rules:**

- Address the letter to a specific person whenever you can.
- Research the organization first and tailor the letter to the situation.
- Concise and factual; no more than one page; no flowery language.
- Give examples that support the claimed skills and qualifications, with real numbers where they exist ("20% increase in membership", "group of 10 fifth graders").
- Put yourself in the reader's shoes: what convinces them the user is ready and able to do the job?
- Don't overuse "I" — vary sentence openings.
- It is a marketing tool: use plenty of action words.
- Reference skills or experiences from the job description and draw explicit connections to the user's credentials.
- Check formatting after PDF conversion; get a second reader before sending.

**Letter pattern to imitate:** paragraph 1 — year/school/major, the exact position and where it was posted, three strengths to bring; paragraph 2 — the organization's mission tied to a concrete experience ("designed and taught … classes to a group of 10 fifth graders"); paragraph 3 — a second experience with measured results ("20% increase in our membership base and a 15% increase in social media engagement") linked to the role; paragraph 4 — thanks and a request for a conversation.

## Final review checklist (run before returning any resume or letter)

The five most common mistakes — confirm none are present:

1. Spelling or grammar errors
2. Missing email or phone
3. Passive language or "I" statements instead of action verbs
4. Not well organized, concise, or easy to skim
5. Not demonstrating results

Then confirm:

- [ ] Every line starts with an action verb (varied across lines); no pronouns; phrases not sentences; articles dropped; most relevant task first in each entry; never "Duties"/"Responsibilities"
- [ ] Quantified wherever real numbers exist; numerals vs. words consistent; nothing fabricated or exaggerated; no filler entries
- [ ] Headings ordered by importance to the target role; entries reverse chronological; keywords from the job description present; no unexplained gaps (e.g., a missing summer)
- [ ] Every entry has organization, city/state, title, and dates in the same layout; state abbreviations, date format ("May 2026" or "05/2026", "Present" for current roles, one month style throughout — never a bare two-digit year, never 4/17/2026, never a line starting with a date), capitalization (degrees, majors, seasons), bold/italics, and alignment consistent throughout; bullet vs. paragraph style consistent
- [ ] One page for students/recent grads (name on page 2 if two pages); ≥10 pt font; ≥0.5" margins; ≤2 fonts — measured on the rendered PDF; balanced white space
- [ ] Professional school/personal email (no workplace email); no photo (unless performer), age, gender, or references on the page
- [ ] Organization names/acronyms spelled out on first use; hyphenated compound terms protected from line-end breaks; no "w/"-style abbreviations, slang, or casual wording; every section heading canonical (Professional Summary, Education, Technical Skills, Experience, Projects, Certifications …)
- [ ] Professional Summary present when the resume targets a posting; each required skill in summary + skills line + one bullet, none past three mentions; skills line categorized; no placeholder text (`[N]`, `\fillin`, `TBD`) anywhere
- [ ] GPA shown if 3.5+ or requested; coursework only if relevant (electives/upper-level); Technical Skills right after Education for tech roles; skill levels labeled honestly
- [ ] Objective (if any) names a specific position and is dropped when a cover letter is sent; interests (if any) specific, about three, relevant
- [ ] Formatting survives PDF conversion — verified by extracting the text (`pdftotext` default mode): contact block in the first five lines, headings on their own lines, dates beside their entries, Education dates on their degree lines, no fused words; single column, no text boxes or sidebars, no contact info in header/footer; fonts embedded with Unicode maps, no Type 3 rows in `pdffonts`; resume and cover letter share font type and size; cover letter addressed to a named person with a colon, one page, examples tied to the job description, "I" not overused
- [ ] `ats-beater` run on the final PDF when available, and its fixes applied
- [ ] User told to read it aloud and get a second reader

## Sources

- Harvard FAS Mignone Center for Career Success, "Harvard College Guide to Creating a Strong Resume": https://careerservices.fas.harvard.edu/resources/create-a-strong-resume/
- NYU Tisch Office of Career Development, "Resume Guidelines and Samples" (Dos & Don'ts and FAQs by Erin Carlisle)
- ATS structure rules: lesson "How ATS reads, maps, and scores resumes" (ingestion pipeline, four scoring dimensions, density cap, three keyword zones, layout failure modes) and calibration from scoring real LaTeX resumes with the `ats-beater` skill, 2026-09-21/22 (multi-row alignment tables extract column-first, scaled fonts render under 10 pt, hyphenated terms fuse on extraction, stacked single-row tables still form a column, `\textbullet` under OT1 yields a bitmap font)
# MODULE legal — LEGAL privacy and policy

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


Agent drafts and wires; **a human (ideally a lawyer) approves any text that goes live.** Ask the dev for entity name, address, regions, minors policy, refund terms (§B5).

| ID | Lvl | Tag | Requirement | Check |
|---|---|---|---|---|
| LEG-01 | L2 | auth public | Privacy Policy and Terms exist and are linked from footer and signup/login | recon `privacy=`/`terms=` ≥ 1; `gg 'privacy\|terms' <footer, login>` |
| LEG-02 | L2 | all | Data minimization: collect only what the product needs; list every personal field and its purpose | schema review |
| LEG-03 | L2 | auth | Account deletion path that removes personal data (DB rows, files, auth user) and data export | `gg 'deleteUser\|deleteAccount\|exportData' $SRC` |
| LEG-04 | L3 | public | Consent banner only if non-essential cookies/trackers load; essential auth cookies need none. If analytics added later, gate it behind consent in the regions that require it | `gg 'gtag\|googletagmanager\|plausible\|posthog\|analytics\|fbq' $SRC package.json` → none = no banner |
| LEG-05 | L3 | all | Subprocessor list (hosting, DB, AI, email, analytics) in the privacy policy | policy text |
| LEG-06 | L3 | public | Business name, address, contact in footer/imprint where required | footer |
| LEG-07 | L3 | public | No fabricated testimonials, fake counters, invented stats, or unearned ratings | `gg 'testimonial\|[0-9][0-9,]+\+? (users\|customers)\|rated [0-9]' $SRC` → each real |
| LEG-08 | L3 | all | Third-party licenses compatible (deps, fonts, icons, images); fonts self-hosted or consented | `npx license-checker --summary` (ask) ; font imports |
| LEG-09 | L3 | public | No placeholder content in production (lorem, stock URLs like picsum/unsplash placeholders, "TODO") | `gg -i 'lorem ipsum\|picsum\|placehold' $SRC` (page/copy files; ignore code comments) |
| LEG-10 | L3 | pay | Prices, taxes, billing interval, renewal and cancellation visible before payment; one-click cancel; refund policy | pricing + checkout |
| LEG-11 | L3 | email | Marketing email: explicit opt-in, unsubscribe link + header | email templates |
| LEG-12 | L3 | ui | No dark patterns: pre-checked upsells, hidden cancel, fake urgency | UI review |
| LEG-13 | L2 | minors | Children's data (COPPA/age-gating) if under-13/16 can sign up; otherwise block and state minimum age | signup flow |
| LEG-14 | L4 | all | DPA/SCCs, data residency, retention schedule, breach-notification runbook | docs |
| LEG-15 | L4 | ui | Accessibility statement / conformance claim (WCAG 2.1 AA) | page |

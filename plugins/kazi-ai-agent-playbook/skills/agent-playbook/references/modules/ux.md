# MODULE ux — UX frontend design, a11y, Figma

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


Tag for every item: `ui` (UX-14/15 also need `public`).

## A. Design workflow (agent order)
1. **Source of truth**: Figma link/node given → Figma MCP (rules in C). None → project tokens + existing components. Never invent a new visual language.
2. **Recon**: `git grep -nE` the token file(s) and the nearest existing component before writing UI (reuse > extend > create).
3. **Direction (new screens only)**: one design skill (`impeccable`, plus at most one taste skill for marketing). Not stacked.
4. **Build** with the project's styling system and tokens only.
5. **Verify in a real browser**: screenshots at 390/768/1280, keyboard walk, console clean, empty/loading/error states forced. Confirm the dev-server port first (ports vary).
6. **Audit**: states + a11y + copy (below), then update the token file / product doc in the same commit if a pattern was added.

## B. Requirements
| ID | Lvl | Requirement | Check |
|---|---|---|---|
| UX-01 | L1 | Uses project design tokens; no new raw colors/spacing/fonts in components | `gg '#[0-9a-fA-F]{3,8}\b\|rgba?\(\|hsla?\(\|oklch\(' '*.tsx' '*.jsx' '*.ts' '*.js' '*.vue' '*.svelte' '*.astro' '*.html'` → only token files, OG/error pages that render outside the CSS pipeline |
| UX-02 | L1 | Reuse existing components before creating new ones | graph search / `git grep` component name |
| UX-03 | L2 | Every async surface has loading, empty (with next action), error (with retry), and disabled states | force each state in the browser |
| UX-04 | L2 | Responsive at 390/768/1280, no horizontal scroll, tap targets >= 44px on touch | Playwright resize + screenshot |
| UX-05 | L2 | Keyboard: logical Tab order, visible focus ring, Enter/Space activate, Esc closes overlays and returns focus | Playwright key presses |
| UX-06 | L2 | Forms: label per field, inline validation, errors tied via `aria-describedby`, input preserved on error, correct `type`/`autocomplete`, no placeholder-as-label | read form components |
| UX-07 | L2 | Destructive actions confirm or offer undo; autosave shows status and failure | UI |
| UX-08 | L2 | Custom 404 and error pages (404 not-found, route error, global error) with a way home | [next] recon `not-found=`, `global-error=` |
| UX-09 | L3 | Contrast >= 4.5:1 text, 3:1 UI/large text, both themes if theming exists | compute from tokens |
| UX-10 | L3 | Icon-only controls have accessible names; images have `alt` (decorative `alt=""`); headings sequential, one `<h1>` | `gg '<img ' ` without alt; snapshot tree |
| UX-11 | L2 | Reduced motion: see UX-22 | see UX-22 |
| UX-12 | L3 | Status changes announced (`role="status"`/`aria-live`) for toasts, autosave, validation | grep |
| UX-13 | L3 | Skeletons (`loading.tsx`/Suspense) where data fetch > ~300ms to avoid layout shift | [next] recon `loading=` |
| UX-14 | L3 | Copy: active voice, short paragraphs (2-3 sentences), specific headlines with outcome, CTA = verb + result, objection handled beside CTA only if true, no filler/jargon; user-visible text free of AI tells (stacked em dashes, "unlock", "seamless") | read page copy |
| UX-15 | L3 | Value proposition and primary CTA above the fold at 1280x720 and 390x844 | screenshots |
| UX-16 | L3 | Dark mode (if supported) uses tokens, not inverted filters; print/export artifacts keep their own fixed theme | tokens |
| UX-17 | L4 | i18n-ready: no hard-coded strings in components, locale-aware dates/numbers, RTL checked | grep |
| UX-18 | L4 | Automated axe scan in CI; manual screen-reader pass (VoiceOver/NVDA) on core flow | CI + manual |

## B2. Motion rules (animation is communication, not decoration)
| ID | Lvl | Requirement | Check |
|---|---|---|---|
| UX-19 | L2 | Every animation has a purpose: feedback, state change, hierarchy, or spatial continuity. None on high-frequency or keyboard-driven actions (typing, list navigation, repeated clicks) | inventory + purpose column |
| UX-20 | L2 | Animate `transform` and `opacity` only; never width/height/top/left/margin/box-shadow; no layout shift while animating | `gg 'transition(-property)?:[^;]*(width\|height\|top\|left\|margin\|box-shadow)'` → none |
| UX-21 | L2 | Timing: micro-feedback 100-200ms, element transitions 200-300ms, large/page <= 500ms; ease-out entering, ease-in leaving; no `linear` except progress/looping; interruptible (reversing mid-way is smooth) | read durations/easings |
| UX-22 | L2 | Every non-essential animation has a `prefers-reduced-motion` fallback (instant or simple fade); no information is conveyed by motion alone | `gg 'prefers-reduced-motion'` covers each animation source |
| UX-23 | L3 | One motion system: shared duration/easing tokens reused everywhere, one entrance pattern per surface, consistent directions | tokens file; grep for raw `ms`/`cubic-bezier` in components |
| UX-24 | L3 | No dropped frames: no JS scroll handlers driving animation (use CSS, IntersectionObserver or scroll-timeline); `will-change` only on elements animating now; test on a throttled CPU | Playwright trace / DevTools performance |
| UX-25 | L3 | Animation never delays the primary action or hides content (> ~300ms wait before interaction); loaders appear only after ~300ms; skeletons preferred to spinners for layouts | manual |

**Animation audit (when asked, or when touching animated UI):** 1) `gg 'transition\|animation\|@keyframes\|framer-motion\|motion/react\|gsap\|useSpring\|view-transition'` to inventory. 2) For each: purpose, properties, duration/easing, reduced-motion fallback. 3) Mark violations against UX-19..25. 4) Propose opportunities only where a state change is currently abrupt (menu open/close, toast, save status, route change, drag-drop, validation). 5) Output one table `file:line | what | verdict | fix`.

## C. Figma → code (when the connector is authorized; otherwise skip and say so)
- Fetch **only the linked node**; ask for a node id, never crawl a file.
- Map each Figma variable (color, spacing, radius, type) to an existing token; if none matches, propose a new token in the token file, never inline the value.
- Figma component ↔ existing React/Vue component by name; reuse props, don't fork.
- Export icons/illustrations as SVG, photos as AVIF/WebP into the static folder; no base64 in components.
- Compare screenshot at the frame's width; fix differences > 2px or semantic (hierarchy, spacing rhythm, states) only.
- Ask the dev when the design conflicts with accessibility (contrast, target size) and propose the nearest compliant value.
- If Figma is unreachable: one-line note, proceed from tokens, do not guess the design.

## D. Design skills (first match; at most ONE style preset per project, `references/skill-registry.md` §Skill budget)
| Capability | Provider (examples; names vary by pack) | Fallback if missing | Access |
|---|---|---|---|
| UI design / critique / polish | `impeccable:impeccable` | `references/modules/ux.md` rules + existing components | plugin marketplace |
| Design tokens, specs, accessible primitives | `ui-ux-pro-max:design-system`, `ui-styling`, `ui-ux-pro-max` | Project's own token file | plugin |
| Redesign without breaking behavior | `redesign-existing-projects` | Small diffs + screenshots before/after | plugin |
| Design source (Figma) | Figma connector | Ask dev for exported tokens/SVG; design from tokens | **User authorizes in claude.ai connector settings or `/mcp`; agent cannot** |
| Charts | `dataviz` | Project's chart lib defaults + `references/modules/ux.md` | plugin |
| Animation audit / review | `improve-animations`, `review-animations`, `find-animation-opportunities` (names vary by pack) | `references/modules/ux.md` §Motion rules (UX-19..25) and its audit step | plugin |
| Motion vocabulary / UI polish details | `animation-vocabulary`, `emil-design-eng` | `references/modules/ux.md` §Motion rules | plugin |
| Clickable prototype before building | `prototype` | Static HTML mock or a single throwaway route, deleted after sign-off | plugin |
| Choosing a component library | `pick-ui-library` | Decide on: accessibility of primitives, bundle size, license, maintenance, theming fit with existing tokens; present 2 options and ask the dev | plugin |
| Style preset (pick ONE per project, see Skill budget) | `design-taste-frontend` / `taste-skill`, `minimalist-ui`, `high-end-visual-design` / `soft-skill`, `industrial-brutalist-ui`, Apple-style motion skill | Existing design language and tokens | plugin |
| Brand / logo / identity | `brandkit`, `ui-ux-pro-max:brand` | Existing brand assets; ask dev | plugin |

Missing → `references/skill-registry.md` §Missing.

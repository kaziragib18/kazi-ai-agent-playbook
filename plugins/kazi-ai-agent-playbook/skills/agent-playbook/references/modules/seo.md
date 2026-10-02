# MODULE seo — SEO technical and answer-engine

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


Tag for every item: `public`.

| ID | Lvl | Requirement | Check |
|---|---|---|---|
| SEO-01 | L2 | App, dashboard, API, auth and internal routes are `noindex`/disallowed; marketing routes indexable; no accidental global `noindex` | read robots + metadata; `git grep -n noindex` |
| SEO-02 | L2 | Unique title (≤ ~60 chars) and meta description (≤ ~155) per route via the framework metadata API | each `page.*` exports metadata; recon pages without |
| SEO-03 | L2 | `robots.txt` valid and points at the sitemap; sitemap lists every indexable URL (including dynamic ones) | recon `robots=`, `sitemap=` |
| SEO-04 | L3 | Canonical URL per page; one canonical host (www/apex) and HTTPS redirect; HSTS | metadata `alternates.canonical` |
| SEO-05 | L3 | One `<h1>` per page; sequential headings; descriptive link text; clean lowercase-hyphen slugs | snapshot |
| SEO-06 | L3 | Open Graph + Twitter card with 1200x630 image per key page | `opengraph-image` files |
| SEO-07 | L3 | JSON-LD matches visible content: `SoftwareApplication`/`Organization` (home), `FAQPage` only where a real FAQ is visible, `BreadcrumbList` on nested pages; validates; no invented ratings | `gg 'ld+json'` ; validator |
| SEO-08 | L3 | Custom 404 returns HTTP 404 (not 200); removed pages 301/410; no broken internal links | crawl with `curl -I` on sitemap sample |
| SEO-09 | L3 | Favicon set (`.ico`, SVG), `apple-touch-icon`, web manifest | files in app/public |
| SEO-10 | L3 | Core Web Vitals (PERF-10) and mobile usability pass on indexable pages | Lighthouse |
| SEO-11 | L3 | No placeholder/duplicate/thin pages indexed (programmatic pages need unique substantive content) | sample pages |
| SEO-12 | L3 | Answer-engine friendly: question as heading, 40-60-word direct answer first, facts consistent across pages, stats sourced | read key pages |
| SEO-13 | L3 | Internal links connect related feature, use-case, docs and pricing pages | link graph sample |
| SEO-14 | L3 | Search Console and Bing Webmaster verified, sitemap submitted (date recorded) | dev confirms |
| SEO-15 | L4 | `hreflang` for locales; log-file/crawl budget review for large sites | |

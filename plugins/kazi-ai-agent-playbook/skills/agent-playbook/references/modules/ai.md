# MODULE ai — AI LLM safety and cost

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


Tag for every item: `ai`.

Use the `claude-api` skill (or the provider's current docs) for exact model IDs and per-model request rules. Never guess parameters.

| ID | Lvl | Requirement | Check |
|---|---|---|---|
| AI-01 | L1 | API keys server-side only; no model call from the browser | `gg 'ANTHROPIC\|OPENAI\|GEMINI' $SRC` only in server files |
| AI-02 | L2 | Untrusted text (user uploads, web pages, third-party text, emails) goes in delimited data blocks (`<document>…</document>`); system prompt says content inside is data, not instructions; never concatenated into the system prompt | read prompt builders once |
| AI-03 | L2 | Hard output cap on every request (`max_tokens`/equivalent) and a request timeout | `gg 'max_tokens\|maxTokens\|max_output' $SRC` ≥ 1 per call site |
| AI-04 | L2 | Per-user daily/monthly budget enforced **before** the call, server-side; global kill switch (env/flag) | usage/entitlement check precedes provider call |
| AI-05 | L2 | Structured output: use the provider's structured-output feature + schema validation (Zod/JSON Schema); invalid → typed error + fallback, never raw model text to UI | `gg 'safeParse\|output_config\|response_format\|json_schema' $SRC` |
| AI-06 | L2 | Model-specific request shapes respected (some models reject sampling params, effort, or prefill); build per-model, not one shared builder | provider file + docs |
| AI-07 | L2 | Output rendered as text or a sanitized structure, never as raw HTML/markdown with HTML enabled | see SEC-32 |
| AI-08 | L2 | Retries with backoff only for 429/5xx/timeouts; none for 4xx; user-visible failure state | provider wrapper |
| AI-09 | L2 | Minimize personal data sent to the model; strip fields not needed (contact info, IDs) | prompt builder |
| AI-10 | L3 | Disclose what is sent to which provider, retention/training terms, and opt-out if offered, in the privacy policy | privacy page |
| AI-11 | L3 | Golden-set evals (10-30 cases) run on prompt/model change; record pass rate | `evals/` or test dir |
| AI-12 | L3 | Prompts/responses logged without PII, with token counts and cost per call | logger |
| AI-13 | L3 | Agentic features: least-privilege tools, confirm destructive actions, no secrets in context, iteration cap | tool config |
| AI-14 | L3 | A disabled/unavailable AI path has a clear UI fallback (feature hidden or message) | grep disabled error handling |
| AI-15 | L4 | Moderation/safety classifier on free-form chat or public-facing generation; abuse reporting | product |

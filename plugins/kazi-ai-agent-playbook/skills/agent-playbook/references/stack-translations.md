# Stack translations (non-JS/TS projects)

Most Checks in the modules are written as JS/TS greps. For another stack, use the row below instead of inventing a translation. Load only the column for this project's stack. The first time a row is used, copy it into the project profile's *Check translations* so later sessions don't need this file.

Run them exactly like the module Checks (the `gg` helper, `B3` step 3). `\|` is markdown escaping and `gg` turns it back into `|` (alternation). A literal pipe character is written `[\|]` in the tables, which `gg` turns into `[|]`.

**Calibrate before you trust a PASS.** These patterns are a starting point, not proof. The first time you run one, point it at one file you know should match. If it finds nothing there, fix the pattern before reporting "no hits" as fine. A pattern that silently matches nothing gives a false PASS, the worst result a check can produce.

## Commands (QA-01, QA-02, SEC-51)

| | Python | Go | Ruby (Rails) | PHP (Laravel) |
|---|---|---|---|---|
| Test | `pytest` | `go test ./...` | `bin/rails test` or `bundle exec rspec` | `php artisan test` or `vendor/bin/phpunit` |
| Typecheck / lint | `mypy .` or `pyright` · `ruff check .` | `go vet ./...` · `staticcheck ./...` | `bundle exec rubocop` | `vendor/bin/phpstan analyse` |
| Dependency audit | `pip-audit` | `govulncheck ./...` | `bundle exec bundle-audit check --update` | `composer audit` |
| Dead code | `vulture <src>` | `staticcheck ./...` (U1000 rule) | `debride` | `vendor/bin/phpstan` (unused rules) |

## Security and QA Checks

| ID | Python (Django / FastAPI / Flask) | Go | Ruby (Rails) | PHP (Laravel) |
|---|---|---|---|---|
| SEC-02 secrets in client | Server-rendered: secrets reach the browser only if a template prints them: `gg '(SECRET\|_KEY\|TOKEN)' <template dirs>` → none. With a separate JS frontend: run the original JS Check on that folder. | same idea for `html/template` files | `gg '(SECRET\|_KEY\|TOKEN)' app/views` → none | `gg '(SECRET\|_KEY\|TOKEN)' resources/views` → none |
| SEC-10 identity verified | `gg 'verify_signature.: *False\|verify=False' $SRC` → none | `gg 'ParseUnverified' $SRC` → none | `gg 'JWT\.decode\(.*, *nil, *false' $SRC` → none | `gg 'JWT::decode\|base64_decode' $SRC` → read each hit once: a key must be passed |
| SEC-11 every handler authenticates | Django: `gg -L 'login_required\|LoginRequiredMixin\|permission_classes\|IsAuthenticated' <views files>` → public views only. FastAPI: `gg -L 'Depends\(.*(user\|auth)' <router files>` | read the router setup once: `gg 'Use\(\|Group\(' $SRC`; routes outside the auth group are intentional | `gg 'skip_before_action :authenticate' app/controllers` → each one is intentional; base controller has `before_action :authenticate` | `gg "middleware\(.auth" routes/` → routes outside the auth group are intentional |
| SEC-12 query filters by owner | Django: `gg '\.objects\.(get\|filter)\(' $SRC` → each includes `user=`/`owner=`/`tenant=` or uses a scoped manager. SQLAlchemy: `gg 'session\.(get\|query)\(\|select\(' $SRC` | `gg 'WHERE id *= *\$1\|Where\(.id' $SRC` → each also filters by owner | `gg '[A-Z][a-z]+\.find\(params' app/` → should be `current_user.<things>.find(...)` | `gg '::find(OrFail)?\(\$' app/` → scoped, or followed by `$this->authorize` |
| SEC-30 input validated | `gg -L 'is_valid\(\|BaseModel\|Schema\(\|\.load\(' <handler files>` → bodyless handlers only | `gg -L 'Validate\|validator\.\|Bind(JSON)?\(' <handler files>`; size cap: `gg 'MaxBytesReader' $SRC` | `gg 'params\.permit!' app/` → none; `gg -L 'params\.require' <controllers>` → bodyless only | `gg -L 'validate\(\|FormRequest' app/Http/Controllers` → bodyless only |
| SEC-31 no string-built SQL | `gg '(execute\|raw\|text)\((f.\|.*\.format\(\|.*. % )' $SRC` → none | `gg '(Query\|Exec\|QueryRow)(Context)?\(.*(Sprintf\|\+ )' $SRC` → none | `gg '(where\|find_by_sql\|execute)\(.*#\{' $SRC` → none | `gg '(DB::raw\|whereRaw\|selectRaw\|DB::select)\(.*\$' $SRC` → each uses bindings |
| SEC-32 no unsafe HTML output | `gg '[\|] *safe\|mark_safe\|autoescape off\|Markup\(' $SRC` → static or sanitized | `gg 'template\.HTML\(\|"text/template"' $SRC` → static or sanitized | `gg 'html_safe\|raw\(\|<%==' app/` → static or sanitized | `gg '\{!!' resources/views` → static or sanitized |
| SEC-39 no secrets or PII in logs | `gg '(logger\|logging\|print)[a-z.]*\(.*(token\|password\|email\|prompt)' $SRC` → none | `gg '(log\|slog\|zap\|logrus)\.[A-Za-z]+\(.*(token\|password\|email\|prompt)' $SRC` → none | `gg 'logger.*(token\|password\|email)' $SRC` → none; `config.filter_parameters` lists them | `gg 'Log::[a-z]+\(.*(token\|password\|email)' $SRC` → none |
| QA-06 external services mocked | `gg 'unittest\.mock\|@patch\|monkeypatch\|respx\|responses\|vcr' <test dirs>` | `gg 'httptest\.\|gomock\|testify/mock' <test dirs>` | `gg 'webmock\|vcr\|receive\(' spec test` | `gg 'Http::fake\|Mockery\|->mock\(' tests` |
| UX-08 custom 404 / error pages | Django: `404.html` and `500.html` templates exist, `DEBUG = False` in production | a custom `NotFound` handler is registered | `public/404.html`, `public/500.html` | `resources/views/errors/404.blade.php` |
| UX-13 loading skeletons | N/A for server-rendered pages; with a JS frontend, use the original Check there | N/A unless JS frontend | N/A unless Hotwire/JS frontend shows async data | N/A unless Livewire/JS frontend |

Checks not listed here (headers, CORS, rate limits, cookies, AI items) either work on any stack as written (they grep for header names, env var names or provider hosts), or are prose Checks that read config once. If one doesn't fit, translate it once, calibrate it as above, and record it in the profile.

Another stack (Java/Spring, C#/.NET, Rust, Elixir…): follow the same approach. For each row above, find this stack's equivalent sink or call, write the pattern, calibrate it, and record it in the profile. Translations proven on a real project belong in this file (§B14).

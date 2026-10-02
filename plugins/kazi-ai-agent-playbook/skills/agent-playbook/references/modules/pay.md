# MODULE pay — PAY billing

Run Checks with the `gg` helper (see `references/B3-check-protocol.md` step 3). `\|` in tables is markdown escaping; `gg` converts it back.


Tag for every item: `pay`.

| ID | Lvl | Requirement | Check |
|---|---|---|---|
| PAY-01 | L3 | Use hosted checkout/elements; card data never touches your servers (PCI SAQ-A) | integration type |
| PAY-02 | L3 | Webhook verifies signature on the **raw** body before parsing; rejects stale timestamps | handler read |
| PAY-03 | L3 | Webhook is idempotent: event id stored with unique constraint; replays are no-ops | schema + handler |
| PAY-04 | L3 | Entitlements decided server-side from stored subscription state, never from client claims or redirect query params | `gg 'entitle\|plan\|subscription' $SRC` |
| PAY-05 | L3 | One port/adapter for the provider and one for entitlements; enabling a paywall = data/config change, not call-site edits | git diff touches adapters only |
| PAY-06 | L3 | Test mode + sandbox end-to-end: subscribe, upgrade, downgrade, cancel, failed payment, refund, webhook replay | test log |
| PAY-07 | L3 | Dunning and grace period defined; access downgrade on failure is graceful | config |
| PAY-08 | L3 | Prices, currency, tax/VAT handling, renewal date, cancel path shown before purchase; receipts emailed | UI |
| PAY-09 | L3 | Merchant-of-record or tax tooling decided for the sellers' region; provider supports the merchant's country (ask dev) | decision in profile |
| PAY-10 | L3 | Hosting plan permits commercial use (some free tiers forbid it) | platform ToS |
| PAY-11 | L4 | Reconciliation job between provider and DB; fraud/chargeback process | docs |

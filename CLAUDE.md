# CLAUDE.md — rust-plugin-standard

This is the **source of truth** for the DunganSoft Oxide/Rust plugin portfolio:

- `STANDARD.md` — the standard every plugin repo follows (layout, metadata schema,
  8-locale translations, versioning, docs, CI, licensing §9, Codefling cross-posting §10).
- `tools/check-standard.py` — the conformance checker (vendored into each plugin repo,
  run by their `standards.yml`). `0 errors` == conformant.
- `tools/make-icon.py` — regenerates the wolf-paw `templates/icon.png`.
- `tools/make-listing.py` — generates a plugin's `CODEFLING.md` listing pack.
- `tools/sign-plugin.sh` — detached-signs a plugin's `.cs` (code signing, §11).
- `keys/gjdunga.asc` — the public signing key (fingerprint `EAC0A2AE65CC6C9762DD6AF06877843761D5C6E6`); vendored into each plugin repo.
- `templates/` — canonical `manifest.json`/`.umod.yaml`, `.editorconfig`,
  `.gitattributes`, `.plugin-standard.json`, `LICENSE-GPL-3.0.txt`, `EULA.template.md`,
  `CLAUDE.template.md`, doc templates, and the three workflows.

## Portfolio (all free, GPL-3.0, conformant, code-signed §11)
ModernInfoPanel, bottomlesswater, ModernItemBlocker, ModernNoCupboardDecay,
NitroBoostLinker (uMod=true) and PVEDamageGuard (uMod=false: marketplace,
Carbon+Oxide, Reflection/file-IO allowed).
**All repos are signed:** each carries `"signed": true` in `.plugin-standard.json`,
a vendored `keys/gjdunga.asc` + `tools/sign-plugin.sh`, and a committed
`oxide/plugins/<Plugin>.cs.asc`, with the CI signature gate green on `main`.

## Rules
- When you change a rule or a vendored tool here, **re-sync** the vendored `tools/`
  scripts — `check-standard.py`, `sign-plugin.sh`, `make-listing.py`, `make-icon.py`
  — (and any changed workflow/template) into the plugin repos.
- **Code signing (§11):** commits/tags are signed; each plugin's `.cs` carries a detached
  `.cs.asc` (regenerate with `tools/sign-plugin.sh` after any `.cs` change), verified in CI
  against `keys/gjdunga.asc`. The signing private key stays on the maintainer workstation.
- Licensing: GPL-3.0 for free/uMod plugins; the DunganSoft EULA (`templates/EULA.template.md`,
  attorney-review template) for paid/Codefling plugins, which use private repos.
- A license change applies only to **future** versions.

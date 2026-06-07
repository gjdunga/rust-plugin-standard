# CLAUDE.md — rust-plugin-standard

This is the **source of truth** for the DunganSoft Oxide/Rust plugin portfolio:

- `STANDARD.md` — the standard every plugin repo follows (layout, metadata schema,
  8-locale translations, versioning, docs, CI, licensing §9, Codefling cross-posting §10).
- `tools/check-standard.py` — the conformance checker (vendored into each plugin repo,
  run by their `standards.yml`). `0 errors` == conformant.
- `tools/make-icon.py` — regenerates the wolf-paw `templates/icon.png`.
- `tools/make-listing.py` — generates a plugin's `CODEFLING.md` listing pack.
- `templates/` — canonical `manifest.json`/`.umod.yaml`, `.editorconfig`,
  `.gitattributes`, `.plugin-standard.json`, `LICENSE-GPL-3.0.txt`, `EULA.template.md`,
  `CLAUDE.template.md`, doc templates, and the three workflows.

## Portfolio (all free, GPL-3.0, conformant)
bottomlesswater, ModernItemBlocker, ModernNoCupboardDecay, NitroBoostLinker (uMod=true)
and PVEDamageGuard (uMod=false: marketplace, Carbon+Oxide, Reflection/file-IO allowed).

## Rules
- When you change a rule or the checker here, **re-sync** the vendored
  `tools/check-standard.py` (and any changed workflow/template) into the plugin repos.
- Licensing: GPL-3.0 for free/uMod plugins; the DunganSoft EULA (`templates/EULA.template.md`,
  attorney-review template) for paid/Codefling plugins, which use private repos.
- A license change applies only to **future** versions.

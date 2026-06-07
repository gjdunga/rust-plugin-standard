# rust-plugin-standard

The shared standard, conformance checker, and templates for
[DunganSoft](https://github.com/gjdunga) Oxide/Rust plugins. It keeps the whole
plugin portfolio consistent and uMod-submission-ready.

- **[STANDARD.md](STANDARD.md)** — the standard every plugin repo follows.
- **[tools/check-standard.py](tools/check-standard.py)** — conformance checker
  (run in each repo's `standards.yml` CI). `0 errors` == conformant.
- **[templates/](templates/)** — canonical `manifest.json` / `.umod.yaml`,
  `.editorconfig`, `.gitattributes`, `.plugin-standard.json`, doc templates, and
  the three canonical workflows (`compile`, `draft-release-on-tag`, `standards`).

## Using it in a plugin repo

1. Copy `tools/check-standard.py` and `templates/workflows/standards.yml` in.
2. Add `.plugin-standard.json` (from `templates/`) and set `umod` true/false.
3. Bring files into line with [STANDARD.md](STANDARD.md).
4. `python3 tools/check-standard.py .` until it is green.

Workflow templates use `__PLUGIN__` / `__TITLE__` / `__REPO__` placeholders —
substitute the plugin's values when copying.

## Conformant repos

| Plugin | uMod | Notes |
| --- | --- | --- |
| [bottomlesswater](https://github.com/gjdunga/bottomlesswater) | ✅ | |
| [ModernItemBlocker](https://github.com/gjdunga/ModernItemBlocker) | ✅ | |
| [ModernNoCupboardDecay](https://github.com/gjdunga/ModernNoCupboardDecay) | ✅ | |
| [NitroBoostLinker](https://github.com/gjdunga/NitroBoostLinker) | ✅ | |
| [PVEDamageGuard](https://github.com/gjdunga/PVEDamageGuard) | marketplace | `umod=false` (Reflection/file-IO allowed) |

MIT licensed.

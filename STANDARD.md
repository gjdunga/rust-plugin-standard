# DunganSoft Plugin Standard

The shared standard every DunganSoft Oxide/Rust plugin repository follows. It
exists so the whole portfolio looks and behaves like one maintained product
line, and so uMod-targeted plugins meet uMod's submission rules. Conformance is
enforced by [`tools/check-standard.py`](tools/check-standard.py), run in CI on
every push and PR (`.github/workflows/standards.yml`).

A repo is **conformant** when the checker reports `0 errors`. Warnings are
allowed but should be driven to zero.

---

## 1. Repository layout

```
oxide/plugins/<Plugin>.cs            # the single shipped source file
oxide/config/<Plugin>.json           # sample configuration (uMod convention)
oxide/lang/<locale>/<Plugin>.json    # one per standard locale (see §4)
build/<Plugin>.csproj                # out-of-server compile chain
tools/fetch-references.sh|.ps1       # reference-assembly fetchers
tools/check-standard.py              # vendored conformance checker
.github/workflows/compile.yml        # compile gate
.github/workflows/draft-release-on-tag.yml  # release automation
.github/workflows/standards.yml      # conformance gate
manifest.json  .umod.yaml            # metadata (canonical schema, §3)
README.md INSTALL.md CHANGELOG.md CONTRIBUTING.md SECURITY.md BUILD.md
LICENSE  icon.png
.editorconfig  .gitattributes  .gitignore  .plugin-standard.json
```

File names are **case-exact**: `LICENSE` (no extension), `CHANGELOG.md`,
`README.md`, `INSTALL.md`, `CONTRIBUTING.md`, `SECURITY.md`, `BUILD.md`.

`<Plugin>` is the plugin class name (PascalCase, no spaces) and must equal the
`.cs` filename, the `manifest.name`, and the lang-file basename.

## 2. The plugin source (uMod rules)

- One file at `oxide/plugins/<Plugin>.cs`, `namespace Oxide.Plugins`, class name == filename.
- `[Info("Title With Spaces", "<author_handle>", "x.y.z")]` — the author field is
  the **uMod username** (`gjdunga`), not a display name. Display credit lives in
  the file header, README, and `manifest.author`.
- `[Description("...")]` present and meaningful.
- No `System.Reflection` (`GetField`/`GetProperty`/`GetMethod`/`BindingFlags`/…) —
  uMod blocks it. Commercial-marketplace plugins are exempt (`"umod": false`).
- Permissions registered via `permission.RegisterPermission` and listed in `manifest.permissions`.
- Player-facing text goes through the Oxide lang API (`LoadDefaultMessages`).

## 3. Metadata schema (identical across all repos)

`manifest.json` (top-level keys, in this order):
`name, title, version, author, author_handle, description, license, game,
language, tags, permissions, commands, compatibility, links`.

- `author` = display name (`Gabriel Dungan (DunganSoft Technologies)`); `author_handle` = `gjdunga`.
- `compatibility` = `{ "oxide_minimum": "...", "oxide_verified": "..." }`.
- `links` = `{ "source", "documentation", "issues", "website" }`.

`.umod.yaml` mirrors the subset: `name, title, version, author, author_handle,
description, game, language, license, tags`.

## 4. Translations

Every repo ships **exactly these eight locales**:
`en, es, ru, la, zh-CN, de, fr, pt`.

- `oxide/lang/en/<Plugin>.json` is the canonical key set.
- Every other locale has the **same keys** as `en` — no missing keys, no orphans.
- Format placeholders (`{0}`, `{1:00}`, `{named}`), `<color=#…>` tags, `\n`, and
  command literals (`/cmd`) are **preserved identically** in every locale.
- Files are flat key→string JSON (no outer wrapper object).

## 5. Versioning

One version string, identical in: `[Info]`, `manifest.version`, `.umod.yaml`
version, the top `CHANGELOG.md` heading, and the README version line. SemVer.
Any user-visible change ships a version bump and a `CHANGELOG.md` entry
(Keep a Changelog format) plus, where a release-notes file is used, a matching
`.github/release-notes/v<x.y.z>.md`.

## 6. Documentation

- **README.md** — sections in order: title + badges, one-line summary, Features,
  Installation, Permissions, Commands, Configuration, Localization, Compatibility, Credits/License.
- **INSTALL.md** — install / update / permissions / uninstall / troubleshooting.
- **CHANGELOG.md** — Keep a Changelog, newest first, dated (UTC).
- **CONTRIBUTING.md**, **SECURITY.md**, **BUILD.md** — present in every repo.

## 7. CI

Three workflows in every repo: `compile.yml` (type-checks against real
Oxide/Rust assemblies), `draft-release-on-tag.yml` (drafts a release on a
`v*.*.*` tag, attaching the `.cs` and all locale files), and `standards.yml`
(runs the conformance checker). All three must be green on `main`.

## 8. Per-repo config (`.plugin-standard.json`)

```json
{
  "umod": true,
  "author_handle": "gjdunga",
  "locales": ["en","es","ru","la","zh-CN","de","fr","pt"],
  "config_required": true,
  "icon_required": false
}
```

Set `"umod": false` for commercial-marketplace plugins (e.g. PVEDamageGuard):
this exempts them from the Reflection ban and the author-handle rule, while every
other rule still applies.

## 9. Licensing

- **Open-source plugins** (free; eligible for umod.org) are licensed **GPL-3.0**.
  Copy `templates/LICENSE-GPL-3.0.txt` to the repo's `LICENSE`, set
  `manifest.license` / `.umod.yaml` `license` to `GPL-3.0`, and carry a short
  GPL notice in the plugin's source header.
- **Paid plugins** (sold on Codefling, etc.) use the **DunganSoft Plugin
  License** (proprietary, source-available, no redistribution) —
  `templates/EULA.template.md`. These are **not** eligible for umod.org, should
  live in **private** repositories, and set `manifest.license` to
  `LicenseRef-DunganSoft-1.0`.
- Note: a license change only applies to **future** versions; versions already
  published under a prior license remain under it.

## 10. Cross-posting to Codefling

Plugins may be listed on Codefling in addition to (free) or instead of (paid)
umod.org.

- Generate a ready-to-paste listing with
  `python3 tools/make-listing.py .` → writes **`CODEFLING.md`** (title, tagline,
  tags, compatibility, dependencies, permissions/commands tables, install steps,
  "what's new" from the changelog, links, license line). Regenerate it on each
  release so the listing tracks the plugin. `CODEFLING.md` is an optional repo
  artifact (not enforced by the checker).
- **Free (GPL-3.0)** plugins cross-post to Codefling as **free** listings and may
  also stay on umod.org.
- **Paid** plugins must use the DunganSoft EULA (§9), live in a **private** repo,
  and are Codefling-only (an open-source license can be redistributed, so it can't
  be meaningfully sold).
- Before publishing a Codefling listing, add the `CODEFLING.md` TODOs: screenshots,
  final price, and a support channel.

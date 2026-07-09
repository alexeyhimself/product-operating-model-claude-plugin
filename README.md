# product-operating-model-claude-plugin

A custom Claude Code **marketplace** that distributes the **Product Coach** plugin — an AI coach grounded in the [Product Operating Model LLM Wiki](https://github.com/alexeyhimself/product-operating-model-llm-wiki).

The plugin is intentionally thin: the knowledge of the model lives in the LLM Wiki repo, not in this skill. On every invocation, the coach reads the wiki, cites specific pages, and grounds its coaching in them.

A copy of the wiki is **bundled inside the plugin** and kept in sync automatically by CI — installing the plugin installs the wiki too. No separate clone, attach, or setup step.

> **Using Codex CLI instead of Claude Code / Cowork?** There's a sibling repo with the same skill packaged for Codex: [`alexeyhimself/product-operating-model-codex-plugin`](https://github.com/alexeyhimself/product-operating-model-codex-plugin). Both plugins bundle the same wiki and are kept in sync by the same source of truth.

## Repository layout

```
.
├── .claude-plugin/
│   └── marketplace.json                  # marketplace catalog
├── .github/
│   └── workflows/
│       └── sync-wiki.yml                 # CI: syncs the bundled wiki copy
└── plugins/
    └── product-coach/
        ├── .claude-plugin/
        │   └── plugin.json               # plugin manifest
        ├── skills/
        │   └── product-coach/
        │       └── SKILL.md              # the coaching skill
        └── wiki/                         # GENERATED — bundled LLM Wiki copy
            ├── SYNC_INFO.md              # source commit this copy was built from
            ├── CLAUDE.md
            ├── index.md
            └── wiki/
```

`plugins/product-coach/wiki/` is a build artifact — never edit it by hand; the next sync overwrites it wholesale.

## Install

In Claude Code:

```
/plugin marketplace add alexeyhimself/product-operating-model-claude-plugin
/plugin install product-coach@product-operating-model
/reload-plugins
```

### Enable auto-update

Auto-update is disabled by default for third-party marketplaces like this one. To receive plugin updates automatically at startup, enable it once:

`/plugin` → **Marketplaces** → select `product-operating-model` → **Enable auto-update**

Without that, you only get updates when you manually run `/plugin marketplace update product-operating-model`.

## Use

After installation, call `/product-coach` skill when you need some guidance or feedback on product: vision, strategy, discovery, delivery, roadmaps, OKRs, PRDs, prototyping, etc.

### The wiki comes bundled

The skill is wiki-grounded: it reads the [Product Operating Model LLM Wiki](https://github.com/alexeyhimself/product-operating-model-llm-wiki) copy that ships inside the plugin (`plugins/product-coach/wiki/`). Nothing to clone or attach. If you prefer to coach against your own clone or fork, attach that folder to your project and tell the coach to use it — the skill treats an attached copy as an override.

## How the wiki stays fresh

Three pieces cooperate:

1. **Wiki repo** (source of truth): a `notify-plugin.yml` workflow fires on every push to `main` and sends a `repository_dispatch` event (`wiki-updated`) to this repo. It authenticates with a fine-grained PAT stored as the `PLUGIN_REPO_TOKEN` secret in the wiki repo.
2. **This repo**: `.github/workflows/sync-wiki.yml` listens for that event (plus a weekly cron as a safety net and a manual `workflow_dispatch` button). It clones the wiki, replaces `plugins/product-coach/wiki/` wholesale, writes `SYNC_INFO.md` with the source commit, bumps the plugin patch version, and commits. If nothing changed, it commits nothing.
3. **Your machine**: with auto-update enabled (see above), Claude Code picks up the new plugin version at startup — wiki updates included.

# product-operating-model-claude-plugin

A custom Claude Code **marketplace** that distributes the **Product Coach** plugin — an AI coach grounded in the [Product Operating Model LLM Wiki](https://github.com/alexeyhimself/product-operating-model-llm-wiki).

The plugin is intentionally thin: the knowledge of the model lives in the LLM Wiki repo, not in this skill. On every invocation, the coach reads the wiki, cites specific pages, and grounds its coaching in them.

## Repository layout

```
.
├── .claude-plugin/
│   └── marketplace.json                  # marketplace catalog
└── plugins/
    └── product-coach/
        ├── .claude-plugin/
        │   └── plugin.json               # plugin manifest
        └── skills/
            └── product-coach/
                └── SKILL.md              # the coaching skill
```

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

### Attach the wiki

The skill is wiki-grounded: it expects the [Product Operating Model LLM Wiki](https://github.com/alexeyhimself/product-operating-model-llm-wiki) to be attached to your Claude Code. On first invocation the skill scans your attached folders for the wiki (looking for `CLAUDE.md` + `index.md` + `wiki/` at the root) and, if it doesn't find it, asks you whether you'd like to clone it yourself or let it clone for you. Either way, attach the resulting folder to your project **marked read-only** — the skill never writes to the wiki and the read-only flag is a belt to the skill's suspenders.

The skill refreshes the wiki at most once a week via `git pull --ff-only`. If the pull is blocked (e.g. the folder is attached read-only at the filesystem level), the skill tells you and asks you to run `git pull` in the wiki folder yourself.

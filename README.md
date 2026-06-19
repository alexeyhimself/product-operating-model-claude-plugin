# product-operating-model-claude-plugin

A custom Claude Code / Cowork **marketplace** that distributes the **Product Coach** plugin — an AI coach grounded in the [Product Operating Model LLM Wiki](https://github.com/alexeyhimself/product-operating-model-llm-wiki).

The plugin is intentionally thin: the knowledge of the model lives in the wiki repo, not in the skill. On every invocation, the coach reads the wiki, cites specific pages, and grounds its coaching in them.

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

In Claude Code or Cowork:

```
/plugin marketplace add alexeyhimself/product-operating-model-claude-plugin
/plugin install product-coach@product-operating-model
```

Once installed, the plugin shows up in Cowork:

![Plugin installed in Claude Cowork](assets/plugin-installed-in-claude-cowork.png)

## Use

After install, the `product-coach` skill triggers automatically when you ask for feedback or guidance on product strategy, discovery, roadmaps, OKRs, PRDs, prototyping, etc.

![Product Coach skill available in Claude Cowork](assets/plugin-available-to-be-called-in-claude-cowork.png)

### Attach the wiki

The skill is wiki-grounded: it expects the [Product Operating Model LLM Wiki](https://github.com/alexeyhimself/product-operating-model-llm-wiki) to be attached to your Cowork project. On first invocation the skill scans your attached folders for the wiki (looking for `CLAUDE.md` + `index.md` + `wiki/` at the root) and, if it doesn't find it, asks you whether you'd like to clone it yourself or let it clone for you. Either way, attach the resulting folder to your project **marked read-only** — the skill never writes to the wiki and the read-only flag is a belt to the skill's suspenders.

The skill refreshes the wiki at most once a week via `git pull --ff-only`. If the pull is blocked (e.g. the folder is attached read-only at the filesystem level), the skill tells you and asks you to run `git pull` in the wiki folder yourself.

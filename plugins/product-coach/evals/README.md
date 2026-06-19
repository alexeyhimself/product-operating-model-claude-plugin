# product-coach evals

Initial eval set for the `product-coach` skill. The format follows the
[skill-creator](https://github.com/anthropics/skills) convention so the same
tooling can run these evals against the installed plugin.

## What's in here

- `evals.json` — 8 evals that target the skill's core behaviors:

  | id | name | wiki attached? | what it tests |
  |----|------|----------------|---------------|
  | 1 | prototyping-discovery-coach | yes | Socratic pullback, prototype-type distinction, [[wiki-page]] citation, 48h next step |
  | 2 | output-driven-roadmap-pushback | yes | Naming the feature-factory framing, outcomes-vs-outputs reframe |
  | 3 | okr-outcome-vs-output | yes | Surfacing outputs-vs-outcomes, refusing to polish output-shaped KRs |
  | 4 | opportunity-solution-tree-build | yes | Torres / continuous-discovery canon, OST structure, situation-specific Socratic |
  | 5 | no-wiki-fallback | **no** | Skill refuses to coach without the wiki, uses `AskUserQuestion`, surfaces the repo URL |
  | 6 | refuse-wiki-write | yes | Read-only guard-rail: refuses to add a page, redirects to the wiki's contribution flow |
  | 7 | wiki-silence-honesty | yes | Honest about gaps; does not fabricate citations |
  | 8 | jumps-to-solution-pullback | yes | Pulling back from "we already decided to build X" to problem / assumption |

Each eval has:

- `prompt` — what the (simulated) user types
- `expected_output` — human-readable description of success
- `expectations` — verifiable statements a grader can check against the run

## Running the evals

The intended runner is the skill-creator's pipeline. The high-level loop:

1. **Spawn runs.** For each eval, launch one subagent _with_ the installed
   plugin available, and one _without_ it (baseline). Save outputs under
   `evals-workspace/iteration-N/eval-<id>/{with_skill,without_skill}/outputs/`.

2. **Capture timing.** When each subagent task completes, save
   `total_tokens` / `duration_ms` to `timing.json` in the run directory.

3. **Grade.** Spawn a grader subagent that reads each `expectations` list
   and produces `grading.json` in each run directory.

4. **Aggregate.** Run

   ```bash
   python -m scripts.aggregate_benchmark \
     evals-workspace/iteration-N \
     --skill-name product-coach
   ```

   from the skill-creator directory. This produces `benchmark.json` and
   `benchmark.md`.

5. **Review.** Launch the eval viewer with

   ```bash
   python /path/to/skill-creator/eval-viewer/generate_review.py \
     evals-workspace/iteration-N \
     --skill-name product-coach \
     --benchmark evals-workspace/iteration-N/benchmark.json \
     --static evals-workspace/iteration-N/review.html
   ```

   and open the resulting HTML.

See the
[skill-creator SKILL.md](https://github.com/anthropics/skills/blob/main/skill-creator/SKILL.md)
for the full workflow.

## Wiki setup before running

Several evals assume the
[Product Operating Model LLM Wiki](https://github.com/alexeyhimself/product-operating-model-llm-wiki)
is attached to the Cowork project marked read-only. Before running any
`wiki_attached: true` eval:

```bash
git clone https://github.com/alexeyhimself/product-operating-model-llm-wiki.git
```

then attach the resulting folder to the Cowork project (read-only).

For eval 5 (`no-wiki-fallback`), the wiki must **not** be attached — that
eval tests the fallback branch where the skill asks the user how to proceed.

## Notes on grading

A few of the expectations are pattern-checkable in a script
(presence of `[[...]]` citation syntax, absence of writes to the wiki path,
presence of a "48 hours" / "by Monday" style closing). Others — like
"pushes back kindly on jumping to a solution" — need an LLM grader.

Keep the script-checkable assertions where they are useful (they're cheap
and deterministic), and let the LLM grader handle the judgment calls.

# sagellm-control-plane-benchmark Copilot Instructions

## Scope
- Package: `isage-control-plane-benchmark`, import path `sage.benchmark_control_plane`.
- Layer: **L4 · bench** — benchmark suite for `sagellm-control-plane` scheduling algorithms.
- Purpose: Control plane scheduling benchmarks covering LLM scheduling, hybrid scheduling, and resource allocation experiments.

## Polyrepo Context (Important)
SageLLM was restructured from a monorepo into a polyrepo. This repo is the dedicated benchmark for `sagellm-control-plane`. It depends on the published `isage-control-plane` package (or local editable install) and should not contain scheduling implementation code.

## Critical rules
- Do not implement scheduling algorithms here; they belong in `sagellm-control-plane`.
- Do not create new local virtual environments (`venv`/`.venv`); use the existing configured Python environment.
- No fallback logic; fail fast.
- `_version.py` is the **sole version source**.

## Architecture focus
- `src/sage/benchmark_control_plane/` — main benchmark package.
  - `experiments/` — experiment definitions.
  - `llm_scheduler/` — LLM scheduler benchmark scenarios.
  - `hybrid_scheduler/` — hybrid scheduler benchmark scenarios.
  - `common/` — shared benchmark utilities.
  - `runner.py` — experiment runner.
  - `reporter.py` — results reporting.
  - `metrics.py` — benchmark metrics.
  - `config.py` — benchmark configuration.
  - `cli.py` — benchmark CLI.
  - `_version.py` — version source of truth.
- `tests/` — unit tests for benchmark infrastructure.

## Workflow
1. Add benchmarks under `src/sage/benchmark_control_plane/experiments/`.
2. Keep experiment configs declarative (YAML/TOML).
3. Use `sagellm-control-plane` as a dependency; do not copy its code.

## Git Hooks (Mandatory)
- Never use `git commit --no-verify` or `git push --no-verify`.
- If hooks fail, fix the issue first.

# Package Migration Guide

## Package Renamed: `isage-control-plane-benchmark` → `isagellm-control-plane-benchmark`

**Effective Date**: February 6, 2026

### Why the Change?

The Control Plane has been moved to the sageLLM repository, so the benchmark package name should reflect this organizational change. The new name `isagellm-control-plane-benchmark` better aligns with:

- sageLLM's PyPI package: `isage-llm`
- Repository name: `sagellm-control-plane-benchmark`
- Better clarity that this benchmarks sageLLM's Control Plane specifically

### Migration Steps

#### 1. Uninstall Old Package

```bash
pip uninstall isage-control-plane-benchmark
```

#### 2. Install New Package

```bash
pip install isagellm-control-plane-benchmark
```

#### 3. Update Code (No Changes Required)

**Good news**: No code changes needed! The Python import path remains the same:

```python
# Import paths stay identical
from sage.benchmark_control_plane import BenchmarkRunner, BenchmarkConfig
from sage.benchmark_control_plane.llm_scheduler import LLMBenchmarkRunner
```

**CLI commands also stay the same**:
```bash
sage-cp-bench run --control-plane http://localhost:8889 --policy aegaeon
```

#### 4. Update Dependencies

If you have `isage-control-plane-benchmark` in your `requirements.txt` or `pyproject.toml`:

**Before**:
```toml
dependencies = [
    "isage-control-plane-benchmark>=0.1.0",
]
```

**After**:
```toml
dependencies = [
    "isagellm-control-plane-benchmark>=0.2.0",
]
```

### Version Mapping

| Old Package | New Package | Notes |
|-------------|-------------|-------|
| `isage-control-plane-benchmark==0.1.0.1` | `isagellm-control-plane-benchmark==0.2.0.0` | Last old version → First new version |

### Old Package Deprecation Timeline

- **February 6, 2026**: New package `isagellm-control-plane-benchmark` released
- **March 6, 2026**: Old package `isage-control-plane-benchmark` will publish deprecation warning
- **June 6, 2026**: Old package may be yanked from PyPI

### GitHub Repository

The repository has also been renamed:

- Old: `https://github.com/intellistream/sage-control-plane-benchmark`
- New: `https://github.com/intellistream/sagellm-control-plane-benchmark`

Git remote URLs will be automatically updated by GitHub.

### Questions or Issues?

- Open an issue: https://github.com/intellistream/sagellm-control-plane-benchmark/issues
- Contact: shuhao_zhang@hust.edu.cn

---

*Last Updated: February 6, 2026*

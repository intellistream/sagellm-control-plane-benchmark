# Old Package Deprecation Plan

## Package: `isage-control-plane-benchmark` (PyPI)

**Status**: Active (to be deprecated)  
**New Package**: `isagellm-control-plane-benchmark`  
**Current Version on PyPI**: 0.1.0.1

---

## Deprecation Steps

### Phase 1: Publish Deprecation Warning (Immediate)

1. **Update `isage-control-plane-benchmark` to 0.1.1.0**:
   - Add deprecation warning to `__init__.py`
   - Keep all functionality intact
   - Point users to new package

2. **Code changes**:

```python
# Add to src/sage/benchmark_control_plane/__init__.py (top of file)
import warnings

warnings.warn(
    "\n" +
    "=" * 70 + "\n" +
    "DEPRECATION WARNING\n" +
    "=" * 70 + "\n" +
    "Package 'isage-control-plane-benchmark' has been renamed to\n" +
    "'isagellm-control-plane-benchmark' to better reflect its\n" +
    "association with sageLLM.\n\n" +
    "Please update your installation:\n" +
    "  pip uninstall isage-control-plane-benchmark\n" +
    "  pip install isagellm-control-plane-benchmark\n\n" +
    "The old package will be maintained until June 2026.\n" +
    "See: https://github.com/intellistream/sagellm-control-plane-benchmark/blob/main/MIGRATION.md\n" +
    "=" * 70,
    FutureWarning,
    stacklevel=2
)
```

3. **Update README.md** in old package:

```markdown
# ⚠️ THIS PACKAGE HAS BEEN RENAMED

**`isage-control-plane-benchmark` is now `isagellm-control-plane-benchmark`**

Please update your installation:
```bash
pip uninstall isage-control-plane-benchmark
pip install isagellm-control-plane-benchmark
```

All imports and CLI commands remain the same - only the package name changed.

See [Migration Guide](https://github.com/intellistream/sagellm-control-plane-benchmark/blob/main/MIGRATION.md)
```

4. **Publish to PyPI**:
```bash
# Switch to old package name temporarily
# Edit pyproject.toml: name = "isage-control-plane-benchmark", version = "0.1.1.0"
python -m build
twine upload dist/*
```

### Phase 2: Final Deprecation Notice (March 6, 2026)

Release version 0.1.2.0 with:
- Stronger warning message
- Recommend immediate migration
- Set warning level to `PendingDeprecationWarning`

### Phase 3: Final Notice & Yank (June 6, 2026)

1. Release final version 0.1.3.0:
   - Add `DeprecationWarning` (most urgent)
   - README prominently displays deprecation

2. After 1 week, yank all old versions on PyPI:
```bash
# Yank old versions (prevents new installs but keeps metadata)
twine yank isage-control-plane-benchmark 0.1.0.1
twine yank isage-control-plane-benchmark 0.1.1.0
twine yank isage-control-plane-benchmark 0.1.2.0
# Keep 0.1.3.0 as reference with deprecation notice
```

---

## Checklist for Old Package v0.1.1.0

- [ ] Clone old package state (before rename)
- [ ] Create branch `deprecation/v0.1.1.0`
- [ ] Add deprecation warning to `__init__.py`
- [ ] Update README with prominent notice
- [ ] Update `pyproject.toml`: version = "0.1.1.0"
- [ ] Test installation and warning display
- [ ] Build package: `python -m build`
- [ ] Upload to TestPyPI first: `twine upload -r testpypi dist/*`
- [ ] Verify TestPyPI installation
- [ ] Upload to PyPI: `twine upload dist/*`
- [ ] Test final installation from PyPI
- [ ] Update documentation

---

## Communication Plan

### Announcement Channels

1. **GitHub**:
   - Create GitHub Release for new package v0.2.0.0
   - Pin issue in old repo about rename
   - Update repo description

2. **Documentation**:
   - Update SAGE main docs
   - Update sageLLM docs
   - Add migration guide to both packages

3. **Social/Community** (if applicable):
   - Blog post about rename
   - Update any tutorials/examples

---

## Rollback Plan

If critical issues arise:
1. Keep old package at 0.1.0.1
2. Pull new package from PyPI
3. Fix issues
4. Re-release with proper version bump

---

**Prepared by**: Zhang Shuhao (ShuhaoZhangTony)  
**Date**: February 6, 2026  
**Next Review**: March 1, 2026

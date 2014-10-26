# Common Issues for Core Contributors

## Overview

This is a page for maintainers to diagnose certain build errors.

## Issues

### `ld: internal error: atom not found in symbolIndex(__ZN10SQInstance3GetERK11SQObjectPtrRS0_) for architecture x86_64`

The exact atom may be different.

This can be caused by passing the obsolete `-s` flag to the linker.

See:
https://github.com/Homebrew/homebrew/commit/7c9a9334631dc84d59131ca57419e8c828b1574b

# Project Rules

This is a markdown blog repo. Posts live in the `posts/` directory as numbered markdown files following the `NNN-Title-With-Dashes.md` naming convention.

## After creating or modifying posts

1. New posts go in `posts/` and must follow the naming convention: `posts/NNN-Title-With-Dashes.md` (e.g., `posts/004-From-Agile-to-Pods.md`).
2. When adding a new post, add a corresponding row to the Posts table in `README.md`.
3. After any change to post files or `README.md`, run the link integrity tests:

```sh
bash test-links.sh
```

All local checks (Check 1: links resolve to files, Check 2: all posts are linked) must pass. Check 3 (live HTTP) may fail for unpushed content — that is expected.

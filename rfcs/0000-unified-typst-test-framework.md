- Feature Name: `unified-typst-test-framekwork`
- Start Date: 2025-08-22
- RFC PR: [typst-community/rfcs#0000](https://github.com/typst-community/rfcs/pull/0000)
- Typst Issue: None

# Summary
[summary]: #summary

A conventional framework for testing Typst packages.

# Motivation
[motivation]: #motivation

There are currently two different test frameworks in use for Typst projects, that of [Tytanic][tytanic-tests] and that of [tinymist][tinymist-tests].
While they have the same goal they are currently entirely incompatible, this presents the possibility of an ecosystem split that should be prevented early.

This proposal aims to answer the following questions:
- What is a test?
- How are tests discovered?
- What kind of tests exist?
- Which steps must be taken to correctly run and check a test?
- Which inputs must be considered to ensure consistent output across different implementations?

With these questions answered tools in the ecosystem will speak a common language when it comes to testing packages, this allows tools to share code and users to chose their tools without fear of incompatibilities.

# Guide-level explanation
[guide-level-explanation]: #guide-level-explanation

TODO

# Reference-level explanation
[reference-level-explanation]: #reference-level-explanation

TODO

# Drawbacks
[drawbacks]: #drawbacks

I can't think of any major drawbacks at the moment.

# Rationale and alternatives
[rationale-and-alternatives]: #rationale-and-alternatives

The point of the unification is to prevent an unnecessary ecosystem split before it forms.
This design of the unified framework was carefully crafted by considering the upsides and downsides of the existing two frameworks and choosing the best parts where possible.

# Prior art
[prior-art]: #prior-art

There are currently two different test frameworks in use for Typst projects, that of [Tinymist][tinymist-tests] and that of [Tytanic][tytanic-tests].

## Tinymist
For Tinymist, tests are top-level functions in an active file and its dependencies (excluding package dependencies) if they start with one of the following prefixes:
- `test-`: Is called and passes if it doesn't panic.
- `bench-`: is called to collect coverage.
- `panic-on-`: Is called and passed if it panics.

Tinymist also supports example tests, files that start with `example-` are compiled and exported as PNG and optional as HTML if they contain a `<test-html-exmaple>`.

TODO: Continue here, elaborate on what example tests do

---

## Tytanic
Tytanic's test framework currently has the following types of tests:
- **compile-only tests**: Typst scripts which are simply compiled but not compared.
  - These tests receive special standard library extensions to be able to check package failure paths like panics.
- **template tests**: Every template package has a single `@template` test which is compiled as if the template was freshly initialized using `typst init`.
  - These tests will treat the self import as special to ensure it can be tested before the package is published.
- **ephemeral tests**: A set of two Typst scripts which are both compiled and compared against each other.
- **persistent tests**: Typst scripts which are compiled and compared against a previous "blessed" version of their own output, this version is manually updated by the user and commonly tracked in the git repo.

All tests (expect for template tests) are placed in a `tests` directory and may be placed in sub directories therein.

In the following example `foo/bar` is a single test **compile-only test**, evident by the lack of both a `ref.typ` file (which would make it a **ephemeral test**) or a `ref` directory (which would make it a **persistent test**).
```
tests/
tests/foo/
tests/foo/bar/
tests/foo/bar/test.typ
```

Temporary output and difference images are stored along side a test script in `out` and `diff` directories respectively.

Tytanic does yet not support doc tests, benchmarks, or test coverage.

## Comparison

TODO: Explain where Tytanic and Tinymist are similar and how this influenced the design.

# Unresolved questions
[unresolved-questions]: #unresolved-questions

TODO

# Future possibilities
[future-possibilities]: #future-possibilities

Once the ecosystem has converged on a unified test framework package submissions to the [universe] can start including their own tests to enable last-minute testing as well as ecosystem-wide test runs akin to those of Rust's [crater].

[tytanic-tests]: https://typst-community.github.io/tytanic/reference/tests/index.html
[tinymist-tests]: https://myriad-dreamin.github.io/tinymist/feature/testing.html
[universe]: https://typst.app/universe
[crater]: https://github.com/rust-lang/crater

- Feature Name: `docstring`
- Start Date: 2025-09-13
- RFC PR: [typst-community/rfcs#6](https://github.com/typst-community/rfcs/pull/6)
- Typst Issue: None

## Summary

This RFC discusses the syntax for docstrings in Typst. A docstring is an item in the source code that holds the documentation of one or multiple language items.

## Motivation

People need to be able to write documentation over language items for their packages.

## The language items that can be documented

This section lists the possible language items that can be documented. Until typst v0.13.1:

- Let bindings. For example, `id` in the following example.
  ```typ
  /// A function that constantly returns its input.
  #let id(x) = x
  ```

- Modules (Files). For example, the file itself.
  ```typ
  /// The file itself is documented by the first line of the file.
  ```

- Destructed variables. For example, `a` and `b` in the following example.
  ```typ
  /// Swaps the values of two variables.
  ///
  /// - `a`: The first element of the tuple.
  /// - `b`: The second element of the tuple.
  #let (a, b) = (b, a)
  ```

- Parameters. For example, `x` and `y` in the following example.
  ```typ
  /// A function that swaps the values of two variables.
  ///
  /// - `x`: The first variable to swap.
  /// - `y`: The second variable to swap.
  #let swap(x, y) = (y, x)
  ```

- Other Expressions. For example, the show rule in the following example.
  ```typ
  /// A show rule that does nothing.
  #show: it => it
  ```

### The reader of docstrings

The reader of docstrings are the _docstring processors_.

- documentation tools, like `tidy`.
- analyzers and test frameworks, like `typst-ide`, `tinymist`, and `tytanic`.

## Existing docstring styles

This section lists the existing docstring styles. Languages put documentation in comments or real strings in specific locations. The comments holding the documentation are usually called doc comments.

### JsDoc-style

Javscript and Typescript use JsDoc-style docstrings.

For example:

```js
/**
 * A function that swaps the values of two variables.
 *
 * @param {number} x - The first variable to swap.
 * @param {number} y - The second variable to swap.
 * @returns {number[]} The swapped values.
 */
function swap(x, y) {
  return [y, x];
}
```

- The documentation are written within a single block comment.
- The each line of the block comment CAN be prefixed with `*` and stripped by the docstring processor.
- The annotations are written within `@param` and `@returns` tags.
- The documentation are written in Markdown format.

### Rust-style

Rust uses Rust-style docstrings.

For example:

```rs
/// A function that swaps the values of two variables.
///
/// # Arguments
///
/// * `x` - The first variable to swap.
/// * `y` - The second variable to swap.
///
/// # Returns
///
/// The swapped values.
fn swap(x: i32, y: i32) -> (i32, i32) {
  (y, x)
}
```

- The documentation are written within consecutive lines of the line comments.
- Each line of the documentation MUST be prefixed with `///`.
- The parameters cannot be documented with special syntax.
- The documentation are written in Markdown format.

### Python-style

Python uses Python-style doc comments.

For example:

```py
def swap(x, y):
    """
    A function that swaps the values of two variables.
    """
    return y, x
```

- The documentation are written within a "dead" long string at the start of the function body.
- The parameters cannot be documented with special syntax.
- The documentation are written in Markdown format.

## Issue 1: The syntax of the content of docstrings

In previous discussion, Markdown Syntax and Typst Syntax are taken into considerations. laurmaedje and people all believes that docstrings should use Typst syntax.

### Issue 1.1: docstrings with compile errors

While a docstring has compile errors, it SHOULD be tolerated when rendering the docstring. Two main reasons can cause "sensible" undefined references:

- processor-specific definitions: _Docstring processors_ can add unique definitions to the scope of a docstring. For example, `example` function is defined by tidy, however, it can be not defined by the official docstring processor.
- definitions in the package to render examples: A common case is that developer would like to create examples with the current definitions provided by the package. However, a definition may be invalid when the developer is editing the code. It is not good if docstrings are not rendered during editing.
- backward compatibility issue: people may use an older version of some _docstring processor_ and definitions are not provided in the older version.

The above example indicates that, only a subset of typst syntax is suggested to be used in docstrings, to allow rendering and parsing with compile errors.

### Issue 1.2: Compile docstrings with external defintions

In Issue 1.1, we mentioned that _Docstring processors_ and developers can add definitions to the scope of a docstring. The definitions from the documented package is particularly concerned. We can catergorize the definitions by their visibility:

- Definitions provided by other packages: the definitions defined by the entry file of a package.
- Definitions provided by other files in the same workspace: the definitions from other files in the same workspace.
- Definitions provided by the current files: the public definitions defined in the current file. In particular, a docstring may access the successor public definitions while is not yet defined while processing the docstring. In particular, a definition can be gone temporarily if a developer is editing the code.
- Private definitions: some definitions may be used or documented, while they are not public or re-exported. for example:
  ````typ
  #let new() = {
      /// Configures the package.
      /// ```example
      /// configure()
      /// ```
    let configure() = todo()
    /// Runs the package.
      /// ```example
      /// configure()
      /// run()
      /// ```
    let run() = todo()
  
    return r(
      configure: configure,
      run: run,
    )un
  }
  #let pkg = new()
  ````

### Issue 1.3: Compile docstrings with processor-specific show rules

Docstring processors may define special show rules to render docstrings. For example, tidy 0.3.0 defines a show rule to render examples:

```typ
#show raw.where(lang: "example"): render-example
```

A docstring processor SHOULD not introduce a show rule if some docstring cannot be rendered without the show rule.

### Issue 2: The syntax of doc comments

The python-style is not suitable for Typst, so we may only consider putting documentation in comments. However, it is not yet decided how doc comments should be written.

#### Issue 2.1: block comments

Rust doesn't allow block comments as doc comments. It is also not suitable for Typst. At least the `*` prefix used by js-doc style is a valid prefix for block comments.

#### Issue 2.2: The place of doc comments

Rust strictly enforces the placement of doc comments. The "Other Expressions" are not allowed to have doc comments. Doc comments of rust CANNOT be placed in a parameter list.

#### Issue 2.3: Module-level doc comments

Rust prefixes module-level doc comments with `//!`. The syntax of module-level doc comments should consider other plain comments at the start of the file.

- shebang: `#!`. Luckily, it is not a valid comment in Typst.
- commented code: A package owner may commented out some code and they may be identified as a module-level doc comment.
- license: A package owner may would like to add a license at the start of the file and before the module-level doc comments. For example:
  ```typ
  // SPDX-License-Identifier: MIT
  /// The file itself is documented by the first line of the file.
  ```
  The package owner may not expect the license to be rendered in the documentation.

## Existing Design

[tinymist.](https://myriad-dreamin.github.io/tinymist/feature/docs.html)

- A doc comment can be started with either `///` or `//` and the comments with same prefix are grouped together as a a single docstring. This is a loosed syntax because of Issue 2: the syntax of doc comments is not yet decided.
- The docstring is in typst syntax and a docstring can only access the public definitions provided by the current package, if it is in a package.
- The valid places are limited to only before "Let bindings" and at the start of the "Modules" (Files), to ensure simple migration to official syntax in future.

## Unresolved questions

All of above issues are unresolved questions.

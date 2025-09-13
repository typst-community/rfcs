#let rfcs(num) = link("https://github.com/typst-community/rfcs/pull/" + str(num))[typst-community/rfcs\##num]
- Feature Name: `docstring`
- Start Date: 2025-09-13
- RFC PR: #rfcs(6)
- Typst Issue: None

= Summary

This RFC discusses the syntax for docstrings in Typst. A docstring is an item in the source code that holds the documentation of one or multiple language items.

= Motivation

People SHOULD have the capability to write documentation about language items.

= The language items that can be documented

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

- Expression Operands. For example, the `a` in the following example.

  ```typ
  #let condition = (
    /// `a` must be greater than `b`.
    a > b and
    /// `a` must be less than `c`.
    a < c
  )
  ```

= Docstring processors

_docstring processors_ parses, checks, and renders docstrings:
- documentation tools, like `tidy`.
- analyzers and test frameworks, like `typst-ide`, `tinymist`, and `tytanic`.

= Existing docstring styles

This section lists the existing docstring styles. Languages identify comments or strings in specific locations as docstrings, and hold the documentation in them. The comments holding the documentation are usually called doc comments.

== JsDoc style

Javscript and Typescript use JsDoc. For example:

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

== Rust style

Rust documents code with doc comments. For example:

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

Besides, Rust allows to add documentation by macros. For example:

```rs
#[doc = "A function that swaps the values of two variables."]
fn swap(x: i32, y: i32) -> (i32, i32) {
  (y, x)
}
```

Rust also allows to include README.md as a module-level docstring.

```rs
#![doc = include_str!("README.md")]
```

== Python style

Python documents code within a long string. For example:

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

= Issue 1: The syntax of the content of docstrings

In previous discussion, Markdown Syntax and Typst Syntax are taken into considerations. official typst and people all believe that docstrings should use Typst syntax.

== Issue 1.1: docstrings with compile errors

While a docstring has compile errors, they SHOULD be tolerated when rendering the docstring. The typicial errors SHOULD be ignored are undefined references. There are three main reasons can cause "sensible" undefined references:
- undefined processor-specific definitions: _Docstring processors_ can add unique definitions to the scope of a docstring. For example, `example` function is defined by tidy, however, it can be not defined by the official docstring processor.
- undefined definitions from the user modules: A common case is that developer would like to create examples with the current definitions provided by the package. However, a definition may be invalid when the developer is editing the code. It is not good if docstrings are not rendered during editing.
- backward compatibility issue: people may use an older version of some _docstring processor_ and definitions are not provided in the older version.

The above example indicates that only a subset of typst syntax is suggested to be used in docstrings, to allow rendering and parsing with compile errors.

== Issue 1.2: Compile docstrings with external defintions

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

== Issue 1.3: Compile docstrings with processor-specific show rules

Docstring processors may define special show rules to render docstrings. For example, tidy 0.3.0 defines a show rule to render examples:

```typ
#show raw.where(lang: "example"): render-example
```

== Issue 2: The syntax of doc comments

The python style is not suitable for Typst, because typst doesn't discard values in python's way. We may only consider putting documentation in comments, either following JsDoc or Rust style. It is not yet decided how doc comments should be written.

=== Issue 2.1: block comments (JsDoc style)

Rust style doesn't allow block comments as doc comments. It is also not suitable for Typst. At least the `*` prefix used by js-doc style is a special markup in typst.

=== Issue 2.2: prefix line comments or not (Two slashes v.s. three slashes)

Rust style prefixes doc comments with three slashes, but official typst hesitates to introduce such syntax for doc comments, considering adding complexity to people who are not familiar with programming languages. Previous discussion shows that many participants also dislike recognize two-slash line comments as doc comments, because the commented code may be occasionally recognized as a doc comment.

Rust style also allows to prefix line comments with a `!` (Unicode `U+0021`). Typst style may not follow that considering the point raised by the discussion mentioned above.

=== Issue 2.3: The place of doc comments

Rust strictly enforces the placement of doc comments.

"Other Expressions" in Rust are not allowed to have doc comments. rustfmt also hates comments in many weird places, especially comments between expression operands, and refuses to format code with weird comment positions.

Existing docstring processors have different opinions on the placement documentation for "Parameters". tidy v0.4.0 places documentation for "Parameters" inside the parameter list. For example:

```typ
#let swap(
  /// The first variable to swap.
  x,
  /// The second variable to swap.
  y,
) = (y, x)
```

tinymist doesn't follow that, with three points:
- It is unfriendly for typst formatters to process comments like that.
- Official typst may not allow to add documentation inside the parameter list, and tinymist will follow official typst.
- New syntax makes it hard to recognize in-place parameter destruction. For example:
  ```typ
  #let exchange((
    /// The first variable to exchange.
    x,
    (
      /// The second variable to exchange.
      y,
      /// The third variable to exchange.
      z,
    )
  )) = ((x, y), z)
  ```

  Some people argues that, in-place parameter destructing in API functions is considered as a bad practice.

=== Issue 2.4: Module-level doc comments

Rust prefixes module-level doc comments with `//!`. The syntax of module-level doc comments should consider other plain comments at the start of the file.

- shebang: `#!`. Luckily, it is not a valid syntax in Typst.
- commented code: A package owner may commented out some code and they may be identified as a module-level doc comment.
- license: A package owner may would like to add a license at the start of the file and before the module-level doc comments. For example:
  ```typ
  // SPDX-License-Identifier: MIT
  /// The file itself is documented by the first line of the file.
  ```
  The package owner may not expect the license to be rendered in the documentation.

= Existing Design: tinymist and tidy v0.3.0

See #link("https://myriad-dreamin.github.io/tinymist/feature/docs.html")[tinymist ] and #link("https://typst.app/universe/package/tidy")[tidy.]

- The docstring is in typst syntax and a docstring can only access the public definitions provided by the current package, if it is in a package.
- The valid places are limited to only before "Let bindings" and at the start of the "Modules" (Files), to ensure simple migration to official syntax in future.
  - A doc comment of let bindings can be started with either `///` or `//` and the comments with same prefix are grouped together as a a single docstring. This is a loosed syntax because of Issue 2: the syntax of doc comments is not yet decided.
  - A doc comment of modules can only start with `///`, because of Issue 2.3: normal comments can occur at the start of the file to include License information.

= Proposed Design

== Valid places

Definite places:

- Before "Let bindings"
- At the start of the "Modules" (Files)

Definite places in future:
- "Custom Types" and their "Fields":
  ```typ
  /// A point in 2D space whose axes coordinate values are of type `T`.
  #type Point(T) = {
    /// The x-axis coordinate of the point.
    field x: T
    /// The y-axis coordinate of the point.
    field y: T
  }
  ```

Possible places and suggested by this RFC:

- Exactly before "Parameters" or "Destructed variables". This is because the parameter list in typst are usually very long.

Possible places and not suggested by this RFC:

- "Other Expressions"

== Syntax of doc comments

Only introduce `///` as the syntax of doc comments.

Despite adding complexity, not introducing new syntax has two disadvantages:
- P1: it is not friendly to add license information when we also want to add a module-level docstring.
- When commenting out code, the commented code may be occasionally recognized as a doc comment or cause failing compilation of the related docstring.
Despite adding complexity, it doesn't add much:
- regular users don't have to learn if they are not going to document code.
- the introduced syntax is relatively easy and it is easy to learn and discover. When one want to add documentation, they can soonly find the syntax in the official documentation by the keyword `docstring` or `documentation`. Tutorial can also mention the syntax in short, because it is simple.

The consecutive doc comments are grouped as a single docstring, and the docstring only documents adjacent "Modules" and "Let bindings". The `/` prefix are removed when parsing the docstring and common indents are removed (dedented) when rendering the docstring.

The Example 1 to 5 all have content "Hello World.":

Example 1 (documenting `id`):

```typ
/// Hello World.
#let id(x) = x
```

Example 2 (documenting `id`):
```typ
/// Hello
/// World.
#let id(x) = x
```

Example 3 (documenting `id`):
```typ
// Random comment.
/// Hello
/// World.
#let id(x) = x
```

Example 4 (documenting the file itself):
```typ
#!/usr/bin/env typst
/// Hello
/// World.

/// Hello World.
#let id(x) = x
```

Example 5 (documenting the file itself):
```typ
#!/usr/bin/env typst
// SPDX-License-Identifier: MIT
/// Hello
/// World.
```

The Example 6 to 8 are all document nothing (incorrect places).

Example 6 (not at the start of the file):
```typ
#!/usr/bin/env typst

/// Hello
/// World.
```

Example 7 (not exactly before "Let bindings"):
```typ
#!/usr/bin/env typst

/// Hello
/// World.

#let id(x) = x
```

Example 8 (not exactly before "Let bindings"):
```typ
#!/usr/bin/env typst

/// Hello
/// World.
// Random comment.
#let id(x) = x
```

== Evaluating the content of docstrings

The content is in Typst syntax. By default, no new definitions can be used in the content of docstrings.

In `typst.toml`, a `docs.prelude` is used to introduce definitions to the content of docstrings. For example:

```toml
[docs]
prelude = "@preview/tidy:0.4.0"
```

And the tidy v0.4.0 package will contain the metadata to help evaluate the content of docstrings.

The computed prelude is directly prepended to the content of docstrings. For example, if `tidy` tells the prelude is `#let example(it) = it.text;` and the content of docstring is `#example[Example]`, the docstring will be compiled with content `#let example(it) = it.text; #example[Example]` and rendered as `Example`.

Sample prelude implementation:

```typ
#let tidy-version = version(sys.inputs.tidy-host-version)
#let example(it) = it.text
#show: it => {
  show ref: it => {
    if tidy-version >= version(0, 4, 0) {
      tidy-render-reference(it) // Provided by tidy or tinymist processor
    } else {
      it
    }
  }

  it
}
```

Sample docstring processor implementation that implements the `tidy-render-reference` function and extracts the base docs and parameter docs:

```rs
let scope = Scope::new();
scope.define::<tidy_render_reference>();
let inputs = typst::dict! { tidy-version: "0.4.0" };
let document: typst::html::HtmlDocument = compile_with_scope(content, &scope, &inputs)?;
let base_docs = convert_to_markdown(document.html()?);
let parameter_docs = typst::query(document, "<tidy-parameter-docs>")?.map(convert_to_markdown);
return Docstring {
  base_docs,
  parameter_docs,
}
```

= Discussion: Backward compatibility of syntax

The docstrings are evaluated based on the prelude defined by official typst (default prelude) and the used docstring processor (custom prelude).

Two main factors can affect the backward compatibility:
- The typst version to render the docstring.
- The docstring processor used to process the docstring.

Since the prelude is defined in `typst.toml`, a minimal typst version can be specified, which determines the default prelude and compiler to render the docstring, ensuring to render the typst syntax used by docstring.

= Discussion: Customized docstring processor

_Docstring processors_ can add show rules to customize the docstring rendering. In the sample prelude implementation, the prelude can do nothing if the host doesn't implement a tidy defined docs interfaces and the parameter docs are left in the "base docs" and shown to the users.

The best practice or design pattern to customize a docstring processor is out of the scope of this RFC, which only discusses the syntax of docstrings.

= Discussion: Error tolerance

As discussed in Issue 1.1, the docstrings SHOULD have syntax that can be extracted partial content even if there are compile errors, which improves editing and developer experience. However, this is optional, and may be discussed in future, because "Backward compatibility of syntax" ensures that when the code has correct syntax, the docstring can be rendered determinsitically with backward compatibility.

= Discussion: Multiple-lingual docstrings and internationalization

If the newline is preserved in the docstring, the documentation in CJK may be rendered with a unwanted space.

```typ
/// 你好，
/// 世界
#let id(x) = x
```

The content of the above docstring may be "你好\n世界" (Unicode `U+4F60 U+597D U+FF0C U+0A U+4E16 U+754C`) and rendered as "你好， 世界" (Unicode `U+4F60 U+597D U+FF0C U+20 U+4E16 U+754C`).

Since a package may target non-programming users and non-English speakers, the internationalization of docstrings is considered a important issue.

These issues are left as an unresolved in this RFC.

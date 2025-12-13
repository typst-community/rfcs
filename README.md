# Community Standards RFCs
This is a repository for drafting, discussing and preparing community standards though the RFC process.
Community RFCs propose standards to implement by community projects with the goal of making the Typst experience consistent and predictable for end users.

We aim to standardize especially the interfaces between various projects in order to make especially tools and packages interoperable and compatible.

## A motivating Example
A classic example for a community standard is the doc comment syntax used by [tinymist], originally introduced by [tidy].
This syntax is not yet supported by Typst and may go through changes before it will, but is already widely used by the community because of the early support by tinymist.

The standardization of this doc syntax would give the community the confidence that this syntax will be supported by community tools and packages without built-in support by the Typst compiler itself.
It would allow also for the design of the syntax to be influenced by a broader set of stakeholders though an open discussion and revision process.

## Contributing
To propose a standard is to create an RFC and have it accepted (merged) into this repository.
The process for creating, revising and implementing an RFC is laid out in [`docs/process.md`][process].

## License
All RFCs and other content in this repository is dual-licensed under MIT or Apache 2.0 (`SPDX-License-Identifier: MIT OR Apache-2.0`).

[tinymist]: https://github.com/Myriad-Dreamin/tinymist
[tidy]: https://github.com/Mc-Zen/tidy

[process]: ./docs/process.md

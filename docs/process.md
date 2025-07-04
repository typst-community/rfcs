# Typst Community RFCs
[Typst RFCs]: #typst-rfcs

The "RFC" (request for comments) process is intended to provide a consistent and controlled path for changes to Typst community standards and widely used features, so that all stakeholders can be confident about the direction of these.

Many changes, including bug fixes and documentation improvements can be implemented and reviewed via the normal GitHub pull request workflow.

Features specific to individual community projects can be done without an RFC.
The RFC process should be used when more than one such project wants to establish a standard for the rest of the community.

Some changes though are "substantial", and we ask that these be put through a bit of a design process and produce a consensus among the Typst community and community developers.
We believe that this process makes the experience of using various community projects more consistent for the end user.

However, note that this is not an authoritative process at the moment.
It is used to explore the feasibility of RFCs for Typst as a whole and "substantial" changes, especially to the compiler itself, may be made outside of this repository.


## Table of Contents
[Table of Contents]: #table-of-contents

- [Opening](#typst-rfcs)
- [Table of Contents]
- [Glossary]
- [When you need to follow this process]
- [Before creating an RFC]
- [What the process is]
- [The RFC life-cycle]
- [Reviewing RFCs]
- [Implementing an RFC]
- [License]
- [Contributions]


## Glossary
[Glossary]: #glossary

- Typst Compiler:
  The open source Typst compiler ([typst/typst][typst]) maintained by Typst GmbH.

- Typst Community:
  The community around the aforementioned compiler at large.

- Community Forge:
  A Discord thread found under `#forge` > `Community` on the [official Typst Discord][discord].

- Typst Forum:
  The [official Typst forum (forum.typst.app)][forum].

- Community Projects:
  Any Typst-adjacent project that is not officially maintained by the Typst GitHub organization.
  For example, the Typst compiler and its Rust dependencies are not community projects, but the [elembic] or [oxifmt] packages by one of the maintainers are.
  This can include but is not limited to language servers, formatters, test runners, package managers, packages, templates, or plugins.

- Ecosystem Team (@typst-community/ecosystem):
  A team consisting of various active community members, some of which maintain community projects.

- RFC:
  A **r**equest **f**or **c**omments is a public document with the intent to gather input regarding a feature or change of substantial impact.
  In the context of the Typst community this impact is mostly restricted to community project, but may also impact the [Typst compiler][typst] itself.

- FCP:
  The **f**inal **c**omment **p**eriod of an RFC is a period of 10 calendar days after the final decision to merge, close or postpone an RFC in which final concerns can be brought up.


## When you need to follow this process
[When you need to follow this process]: #when-you-need-to-follow-this-process

You need to follow this process if you intend to make "substantial" changes to interfaces or standards used by multiple community projects, or the RFC process itself.
What constitutes a "substantial" change is evolving based on community norms and varies depending on what part of the ecosystem you are proposing to change, but may include the following.

- Proposing a standard to be implemented by multiple community projects.
- Any semantic or syntactic change to already accepted standards or conventions that is not a bug fix.
- Deprecating or removing an accepted standard used by multiple community projects.

Some changes do not require an RFC:

- Rephrasing, reorganizing, refactoring, or otherwise "changing shape does not change meaning".
- Additions that strictly improve objective, numerical quality criteria (warning removal, speedup, better platform coverage, more parallelism, trap more errors, etc.)
- Additions only likely to be _noticed by_ other developers-of-typst, invisible to users-of-typst.
- Changes to the Typst compiler which have been discussed at length on the [Typst issue tracker][typst] and/or [community discord][discord].

If you submit a pull request to implement a new feature without going through the RFC process, it may be closed with a polite request to submit an RFC first.


## Before creating an RFC
[Before creating an RFC]: #before-creating-an-rfc

A hastily-proposed RFC can hurt its chances of acceptance.
Low quality proposals, proposals for previously-rejected features, or those that don't fit into the near-term road map, may be quickly rejected, which can be demotivating for the unprepared contributor.
Laying some groundwork ahead of the RFC can make the process smoother.

Although there is no single way to prepare for submitting an RFC, it is generally a good idea to pursue feedback from community project developers beforehand, to ascertain that the RFC may be desirable;
having a consistent positive impact on community projects requires concerted effort toward consensus-building.

The most common preparations for writing and submitting an RFC is discussing the topic in the Community Forge or on the [Typst Forum][forum].
You may file issues on this repository for discussion too, but using the [Typst Discord][discord] is generally the best way to get immediate feedback by the maintainers and community members.

As a rule of thumb, receiving encouraging feedback from long-standing community developers, and particularly members of the relevant projects is a good indication that the RFC is worth pursuing.


## What the process is
[What the process is]: #what-the-process-is

In short, to get a major feature added to multiple projects, one must first get the RFC merged into the RFC repository as a markdown file.
At that point the RFC is "active" and may be implemented with the goal of eventual inclusion into these projects.

- Fork this repository
- Copy `0000-template.md` to `text/0000-my-feature.md` (where "my-feature" is descriptive).
  Don't assign an RFC number yet;
  this is going to be the PR number and we'll rename the file accordingly if the RFC is accepted.
- Fill in the RFC.
  Put care into the details: RFCs that do not present convincing motivation, demonstrate lack of understanding of the design's impact, or are disingenuous about the drawbacks or alternatives tend to be poorly-received.
- Submit a pull request.
  As a pull request the RFC will receive design feedback from the larger community, and the author should be prepared to revise it in response.
- Now that your RFC has an open pull request, use the issue number of the PR to rename the file: update your `0000-` prefix to that number.
  Also update the "RFC PR" link at the top of the file.
- Each pull request will be labeled with the most relevant `T-*` labels, which aids in understanding the scope of an RFC.
- Build consensus and integrate feedback.
  RFCs that have broad support are much more likely to make progress than those that don't receive any comments.
  Feel free to reach out to the RFC assignee in particular to get help identifying stakeholders and obstacles.
- The ecosystem team will discuss the RFC pull request, as much as possible in the comment thread of the pull request itself.
  Offline discussion will be summarized on the pull request comment thread and are generally done within the Community Forge.
- RFCs rarely go through this process unchanged, especially as alternatives and drawbacks are shown. You can make edits, big, and small, to the RFC to clarify or change the design, but make changes as new commits to the pull request, and leave a comment on the pull request explaining your changes.
  Specifically, do not squash commits after they are visible on the pull request if they meaningfully change the semantics of the RFC.
  Squashing typos or formatting changes is OK.
- At some point, a member of the ecosystem team will propose a "motion for final comment period" (FCP), along with a *disposition* for the RFC (merge, close, or postpone).
  - This step is taken when enough of the tradeoffs have been discussed that the ecosystem team is in a position to make a decision.
    That does not require consensus amongst all participants in the RFC thread (which is usually impossible).
    However, the argument supporting the disposition on the RFC needs to have already been clearly articulated, and there should not be a strong consensus *against* that position outside of the ecosystem team.
    Ecosystem team members use their best judgment in taking this step, and the FCP itself ensures there is ample time and notification for stakeholders to push back if it is made prematurely.
  - For RFCs with lengthy discussion, the motion to FCP is usually preceded by a *summary comment* trying to lay out the current state of the discussion and major tradeoffs/points of disagreement.
  <!-- TODO: Should this instead just be a majority? -->
  - Before actually entering FCP, *all* members of the ecosystem team must sign off;
    this is often the point at which many ecosystem team members first review the RFC in full depth.
- The FCP lasts ten calendar days, so that it is open for at least 5 business days.
  It is also advertised widely, e.g. on the [Typst Forum][forum] and [Typst Discord][discord].
  This way all stakeholders have a chance to lodge any final objections before a decision is reached.
- In most cases, the FCP period is quiet, and the RFC is either merged or closed.
  However, sometimes substantial new arguments or ideas are raised, the FCP is canceled, and the RFC goes back into development mode.
- If the RFC is merged a tracking issue is created to track its implementation across various community projects.


## The RFC life-cycle
[The RFC life-cycle]: #the-rfc-life-cycle

Once an RFC becomes "active" then authors may implement it and submit the feature as a pull request to the community project repositories.
Being "active" is not a rubber stamp, and in particular still does not mean the feature will ultimately be merged;
it does mean that in principle all the major stakeholders have agreed to the feature and are amenable to merging it.

Furthermore, the fact that a given RFC has been accepted and is "active" implies nothing about what priority is assigned to its implementation, nor does it imply anything about whether a developer has been assigned the task of implementing the feature.
While it is not *necessary* that the author of the RFC also write the implementation, it is by far the most effective way to see an RFC through to completion: authors should not expect that other project developers will take on responsibility for implementing their accepted feature.

Modifications to "active" RFCs can be done in follow-up pull requests.
Such PRs should update the RFC to include the new PR link.
We strive to write each RFC in a manner that it will reflect the final design of the feature;
but the nature of the process means that we cannot expect every merged RFC to actually reflect what the end result will be at the time of the next major release of community projects or the [Typst compiler][typst] itself.

In general, once accepted, RFCs should not be substantially changed.
Only very minor changes should be submitted as amendments.
More substantial changes should be new RFCs, with a note added to the original RFC.
Exactly what counts as a "very minor change" is up to the ecosystem team to decide.


## Reviewing RFCs
[Reviewing RFCs]: #reviewing-rfcs

While the RFC pull request is up, the ecosystem team may schedule meetings with the author and/or relevant stakeholders to discuss the issues in greater detail.
A summary from the meeting will be posted back to the RFC pull request.

The ecosystem team makes final decisions about RFCs after the benefits and drawbacks are well understood.
These decisions can be made at any time, but the ecosystem team will regularly issue decisions.
When a decision is made, the RFC pull request will either be merged or closed.
In either case, if the reasoning is not clear from the discussion in thread, the ecosystem team will add a comment describing the rationale for the decision.


## Implementing an RFC
[Implementing an RFC]: #implementing-an-rfc

Because the RFCs in this repository are primarily for community standards implementations are usually left to the maintainers of community projects.
For this reason it's integral that they are part of the revision process of the RFC.

The author of an RFC is not obligated to implement it.
Of course, the RFC author (like any other developer) is welcome to post implementations for review after the RFC has been accepted.

Every accepted RFC has an associated issue tracking its implementation in this repository, this can be used to link back to project specific issues to get an idea about the current state of the implementation.

If you are interested in working on the implementation for an "active" RFC, but cannot determine if someone else is already working on it, feel free to ask (e.g. by leaving a comment on the associated issue).


## License
[License]: #license

This repository is currently licensed under either of:

- Apache License, Version 2.0, ([LICENSE.Apache-2.0] or https://www.apache.org/licenses/LICENSE-2.0)
- MIT license ([LICENSE.MIT] or https://opensource.org/licenses/MIT)

at your option.

### Contributions
[Contributions]: #contributions

Unless you explicitly state otherwise, any contribution intentionally submitted for inclusion in the work by you, as defined in the Apache-2.0 license, shall be dual licensed as above, without any additional terms or conditions.


[self]: https://github.com/typst-community

[elembic]: https:github.com/PgBiel/elembic
[oxifmt]: https:github.com/PgBiel/typst-oxifmt

[typst]: https://github.com/typst/typst
[forum]: https://forum.typst.app
[discord]: https://discord.com/invite/y4Fhb6mvDa

[LICENSE.Apache-2.0]: ../LICENSE.Apache-2.0
[LICENSE.MIT]: ../LICENSE.MIT

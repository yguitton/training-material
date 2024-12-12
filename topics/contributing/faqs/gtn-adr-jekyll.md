---
title: "GTN ADR: Why Jekyll and not another Static Site Generator (SSG)"
area: adr
box_type: tip
layout: faq
contributors: [hexylena, shiltemann, bebatut]
---

## Context and Problem Statement

We needed a static site generator for the GTN, one had to be chosen. We chose Jekyll because of it's good integration with GitHub and GitHub Pages. Over time our requirements have changed but we still need one SSG.

## Decision Drivers

* Must be easy for contributors to setup and use
* Needs to be relatively performant (full rebuilds may not take more than 2 minutes.)
* Must allow us to develop custom plugins

## Considered Options

* Jekyll
* Hugo
* A javascript option
* Another SSG.

## Decision Outcome

Chosen option: "Jekyll", because of the amount of time and effort we have sunk into it over the years has made it a good platform for us, despite limitations.

### Consequences

* Good, because it works well for us and has scaled sufficiently to an incredible number of output pages (~3k) with acceptable build times.
* Good, because it has a well supported ecosystem of plugins we can leverage for common tasks
* Good, because we can easily write our own plugins for many tasks.
* Bad, because we it remains difficult to install
* Bad, because people must know Ruby and very few people do (but it isn't that hard to learn!)

## Pros and Cons of the Options

### Hugo

* Good, because it would be a single binary, easier to install
* Bad, because plugins do not exist, it does not have a way to hook the internals and work with them which we use extensively.
* Bad, because what plugins do exist, only exist as 'shortcodes' that are written in Go templates which are not as powerful as Ruby.

### A JavaScript option

* Good, because we could re-use code from other places
* Bad, because the average lifetime of a JavaScript SSG is maybe one year.
* Bad, because they are also quite slow on average (Hub compile times are on the order of 10 minutes.)

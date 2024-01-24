% GRID-DOWNLOAD-XSD(1) Cargill, Incorporated | Grid

<!--
  Copyright 2022 Cargill Incorporated
  Licensed under Creative Commons Attribution 4.0 International License
  https://creativecommons.org/licenses/by/4.0/
-->

NAME
====

**grid-download-xsd** - Downloads and extracts the XSDs necessary for Grid
validation.

SYNOPSIS
========

**grid download-xsd** \[**FLAGS**\] \[**OPTIONS**\]

DESCRIPTION
===========

This command downloads GS1 XSD files used by various Grid features. The
downloaded artifacts are first copied into a cache directory. They are then
expanded into Grid's state directory. If the desired artifacts are in the
cache directory, Grid will not attempt to re-download them, and instead
prefer the cache contents.

To avoid downloading from the internet (for example, if a firewall rule
would prevent access to the remote website), use the --copy-from and
--no-download arguments.

If --copy-from is used without --no-download, artfacts will be copied from
the directory provided via --copy-from and any missing artifacts will be
downloaded as usual.

FLAGS
=====

`--no-download`
: Do not download the XSD even if there is no artifact cached

`--force`
: Continue even if a checksum on the cached file is incorrect

`-h`, `--help`
: Prints help information.

`-q`, `--quiet`
: Do not display output.

`-V`, `--version`
: Prints version information.

`-v`
: Log verbosely.

OPTIONS
=======

`--copy-from`
: Replenish the cache from a directory resource and use that. The directory
  should contain the following files:
  /GS1\_XML\_3-4-1\_Publication.zip

ENVIRONMENT VARIABLES
=====================

**`GRID_CACHE_DIR`**
: Specifies the local path to the directory containing GRID cache.
  The default value is "/var/cache/grid".

**`GRID_STATE_DIR`**
: Specifies the local path to the directory containing GRID state.
  The default value is "/var/lib/grid".

SEE ALSO
========
| Grid documentation: https://grid.splinter.dev/docs/0.3/

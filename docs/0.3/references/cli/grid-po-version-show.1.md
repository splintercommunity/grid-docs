% GRID-PO-VERSION-SHOW(1) Cargill, Incorporated | Grid
<!--
  Copyright 2022 Cargill Incorporated
  Licensed under Creative Commons Attribution 4.0 International License
  https://creativecommons.org/licenses/by/4.0/
-->

NAME
====

**grid-po-version-show** - Show the details of a purchase order's version for a
specific purchase order.

SYNOPSIS
========

**grid po version show** \[**FLAGS**\] \[**OPTIONS**\] <PURCHASE_ORDER_ID> <VERSION_ID>

DESCRIPTION
===========

Show a purchase order version in grid.

ARGS
====

`PURCHASE_ORDER_ID`
: Either a UID or an alternate ID of a purchase order.

`VERSION_ID`
: The purchase order version identifier.

FLAGS
=====

`-h`, `--help`
: Prints help information.

`-q`, `--quiet`
: Do not display output.

`-V`, `--version`
: Prints version information.

`-v`
: Increases verbosity (the opposite of `-q`). Specify multiple times for more
  output.

OPTIONS
=======

`-F`, `--format=FORMAT`
: Specifies the output format of the list. Possible values for formatting are
  `human`, `csv`, `yaml`, and `json`. Defaults to `human`.

`--service-id`
: The ID of the service the payload should be sent to; required if running on
  Splinter. Format: `<circuit-id>::<service-id>`.

`--url`
: URL for the REST API

EXAMPLES
========

The command

```
$ grid po version show PO-AA11A-BB22 1
```

will show version 1 for the purchase order "PO-AA11A-BB22":

```
Version 1:
	Workflow State    proposed
	Is Draft          false
	Revisions         1
	Current Revision  1

Revision 1:
    Created At       <datetime string>
    Submitter        0200ef9ab9243baee...
<Revision XML file>

```

ENVIRONMENT VARIABLES
=====================

**`GRID_DAEMON_ENDPOINT`**
: Specifies a default value for `--url`

**`GRID_SERVICE_ID`**
: Specifies a default value for `--service-id`

SEE ALSO
========
| `grid-po(1)`
| `grid-po-version-create(1)`
| `grid-po-version-list(1)`
| `grid-po-version-update(1)`
| `grid-po-revision(1)`
|
| Grid documentation: https://grid.splinter.dev/docs/0.3/

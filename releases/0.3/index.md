# Grid v0.3 Release

<!--
  Copyright 2024 Bitwise IO, Inc.
  Copyright 2018-2022 Cargill Incorporated
  Licensed under Creative Commons Attribution 4.0 International License
  https://creativecommons.org/licenses/by/4.0/
-->

If you're new to Grid, see the [Grid documentation]({% link docs/0.3/index.md %})
to learn about Grid concepts and features.

Grid v0.3 is the third major release of Grid. Below is a summary of the
features and changes included in this release. For detailed changes related to
the v0.3 release, see the [Grid release notes](https://github.com/splintercommunity/grid/blob/0-3/RELEASE_NOTES.md).

## New and Noteworthy

### Grid Puchase Order

Grid Purchase Order is designed to share purchasing information between trade
partners. The purchase of goods and services is a primary activity within the
supply chain and the communication of order information occurs in various ways
today: by phone, email, SMS, eCommerce marketplaces, Electronic Data
Interchange (EDI), etc. Both the manual coordination and automated,
point-to-point sharing of purchasing information between trade partners present
challenges within day-to-day supply chain operations. Pain points include: poor
data accuracy stemming from manual data entry errors, discrepancies between
systems which impact receiving or result in financial claims, costs related to
administrative/clerical time, and management of custom integrations.

Grid Purchase Order aims to address these pain points by offering a common
industry solution for sharing purchase order information between trade partners
on Grid. Trade partners have the option to integrate this Grid component with
existing systems of record.

### Grid XSD Downloading Utility

Grid now offers the ability to download and extracts schemas used to validate
data. The `grid-download-xsd` command downloads GS1 XSD files used by various
Grid features. The downloaded artifacts are first copied into a cache directory.
They are then expanded into Grid's state directory. If the desired artifacts
are in the cache directory, Grid will not attempt to re-download them, and
instead prefer the cache contents.

For more information, see the [`grid-download-xsd`]({%
  link docs/0.3/references/cli/grid-download-xsd.1.md %}) command documentation.

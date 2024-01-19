# Roadmap

<!--
  Copyright 2024 Bitwise IO, Inc.
  Copyright 2018-2022 Cargill Incorporated
  Licensed under Creative Commons Attribution 4.0 International License
  https://creativecommons.org/licenses/by/4.0/
-->

The following is a community-driven tentative roadmap to future releases.

## Future Releases

### Grid 0.4

| Feature | Status | RFC |  Documentation |
| ------- | ------ | --- | ------------- |
| Griddle | *Under Development* | - | [API planning document]({% link community/planning/rest_api/index.md %}) |
| Batch Tracking | *Under Development* | - | - |

### Features for Future Releases

These features are not yet slated for a release, but work on them has started
in some form.

| Feature | Status | RFC |  Documentation |
| ------- | ------ | --- |  ------------- |
| Product Catalog | *RFC Accepted* | [RFC #14](https://github.com/splintercommunity/grid-rfcs/blob/main/text/0014-catalog.md) | - |

## Latest Release

### Grid 0.3

| Feature | Status | RFC | Documentation |
| ------- | ------ | --- | ------------- |
| Purchase Order | *Complete* | [RFC #25](https://github.com/splintercommunity/grid-rfcs/blob/main/text/0025-purchase-order.md) | [Specification]({% link docs/0.3/grid_purchase_order.md %}) |
| Workflow | *Complete* | [RFC #24](https://github.com/splintercommunity/grid-rfcs/blob/main/text/0024-workflows.md) | [Specification]({% link docs/0.3/workflow_specification.md %}) |

## Past Releases

### Grid 0.2

| Feature | Status | RFC | Documentation |
| ------- | ------ | --- | ------------- |
| Identity (Pike 2) | *Complete* | [RFC #23](https://github.com/splintercommunity/grid-rfcs/blob/main/text/0023-grid-identity.md) | - |
| Product w/GDSN Trade Items| *Complete* | - |
| Update to Actix 3 | *Complete* | - | - |

### Grid 0.1

| Feature | Status | RFC | Documentation |
| ------- | ------ | --- | ------------- |
| Component | *Complete* |  - | - |
| Location | *Complete* | [RFC #20](https://github.com/splintercommunity/grid-rfcs/blob/main/text/0020-location.md) | [Specification]({% link docs/0.1/grid_location_smart_contract_specification.md %}) |
| Pike | *Complete* | - | [HOWTO]({% link docs/0.1/creating_organizations.md %}), [Specification]({% link docs/0.1/pike_transaction_family.md %}), [REST&nbsp;API](/docs/0.1/api/#tag/Pike), [CLI]({% link docs/0.1/references/cli/grid-agent-create.1.md %}) |
| PostgreSQL Support | *Complete* | - | [CLI]({% link docs/0.1/references/cli/grid-database-migrate.1.md %}) [Schema](/docs/0.1/database/postgres/)|
| Product | *Complete* | [RFC #5](https://github.com/splintercommunity/grid-rfcs/blob/main/text/0005-product.md) |  [Overview]({% link docs/0.1/grid_product.md %}), [HOWTO]({% link docs/0.1/creating_products.md %}), [REST&nbsp;API](/docs/0.1/api/#tag/Product), [CLI]({% link docs/0.1/references/cli/grid-product-create.1.md %}) |
| Sawtooth Support | *Complete* | - | [HOWTO]({% link docs/0.1/grid_on_sawtooth.md %})  |
| Schema | *Complete* | - | [Specification]({% link docs/0.1/schema_smart_contract_specification.md %}), [REST&nbsp;API](/docs/0.1/api/#tag/Schema), [CLI]({% link docs/0.1/references/cli/grid-schema-create.1.md %})
|
| Splinter Support | *Complete* | - | [HOWTO]({% link docs/0.1/grid_on_splinter.md %}) |
| Sqlite Support | *Complete* | - | [CLI]({% link docs/0.1/references/cli/grid-database-migrate.1.md %}) |

## Additional Information

### Management of the Roadmap

The roadmap is maintained by the community with oversight of the
[root team](https://github.com/splintercommunity/grid-rfcs/blob/main/subteams/root.md).
Changes to the roadmap are done in the form of pull requests to the
[grid-docs](https://github.com/splintercommunity/grid-docs) repository.

Considering adding a new feature to Grid? Awesome! Feel free to chat about it
on [Discord in
#grid]({% link community/join_the_discussion.md %}#chat)!

### Status

The status column can contain these values:

| Status | Description |
| --- | --- |
| Not Started | No work has actively started on this feature. |
| Discussion | An RFC has not been submitted, but the feature is actively being discussed. |
| RFC Submitted | The RFC has been submitted and is under review. |
| RFC Final Comment Period | The RFC is in final comment period (about a week) and is expected to be approved. |
| RFC Approved | The RFC has been approved by the appropriate subteams. |
| Under Development | The feature is actively being developed. |
| Implemented | The bulk of the implementation is done and the feature is usable. |
| Complete | The feature is ready for the release. |

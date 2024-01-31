# Pike Smart Contract Specification

<!--
  Copyright (c) 2018-2020 Cargill Incorporated
  Licensed under Creative Commons Attribution 4.0 International License
  https://creativecommons.org/licenses/by/4.0/
-->

## Overview

Pike is a smart contract designed to run with the
[Sawtooth Sabre](https://github.com/splintercommunity/sawtooth-sabre/)
smart contract engine.

Pike is designed to track the identities of the actors involved in the supply
chain. These actors are agents and the organizations they represent. The roles
that the agents play within said organizations are also tracked. This
information can be used to determine who is allowed to interact with a platform,
and to what extent they are allowed to interact with the platform.

This specification describes the available data objects, state addressing (how
transaction information is stored and addressed by *namespace*), and the valid
transactions: types, headers, payload format, and execution rules.

## State

### Agent

An agent is a cryptographic public key which has a relationship, defined by
roles, with an organization.  The list of roles can be used by transaction
processors for permissioning or in combination with Smart Permissions.

An agent has five fields:

* public_key: An agent’s cryptographic public key. Only one agent can belong to
  the public key.
* org_id: The identifier of the organization to which the agent belongs.
* active: Whether the agent is currently considered active at the organization.
* roles: A list of roles the agent has with the organization.
* metadata: A list of key value pairs describing organization specific data
  about the agent.

The public_key is the unique key for an Agent.

```protobuf
    message Agent {
        string org_id = 1;
        string public_key = 2;
        bool active = 3;
        repeated string roles = 4;
        repeated KeyValueEntry metadata = 5;
    }

    message KeyValueEntry {
      string key = 1;
      string value = 2;
    }
```

### Agent List

Agents whose addresses collide are stored in an agent list. An agent list
contains one field:

* agents: a list of agents

```protobuf
    message AgentList {
        repeated Agent agents = 1;
    }
```

### Organization

An organization has four fields:

* id: A unique identifier for the organization.
* name: A user defined identifier for the organization.
* address: A physical address for the organization.
* metadata: A list of key value pairs describing data about the organization.

The id is the unique key for an Organization.

```protobuf
    message Organization {
        string org_id = 1;
        string name = 2;
        string address = 3;
        repeated KeyValueEntry metadata = 4;
    }
```

### Organization List

Organizations whose addresses collide are stored in an organization list. An
organization list contains one field:

* organizations: a list of organization


```protobuf

    message OrganizationList {
        repeated Organization organizations = 1;
    }
```

### Addressing

#### Agent State

The specific namespace prefix within Pike for Agent State is cad11d00,
which is the general Pike namespace cad11d concatenated with 00. The
remaining 62 characters are made of the first 62 character of the hash of the
agent's public key.

#### Organization State

The specific namespace prefix within Pike for Organization State is
cad11d01, which is the general Pike namespace cad11d concatenated with 01.
The remaining 62 characters are made of the first 62 character of the hash of
the organization's id.

## Transaction Payload

Pike payloads are defined by the following protocol
buffers code:

```protobuf
    message PikePayload {
        enum Action {
            ACTION_UNSET = 0;

            CREATE_AGENT = 1;
            UPDATE_AGENT = 2;

            CREATE_ORGANIZATION = 4;
            UPDATE_ORGANIZATION = 5;
        }

        Action action = 1;

        CreateAgentAction create_agent = 2;
        UpdateAgentAction update_agent = 3;

        CreateOrganizationAction create_org = 4;
        UpdateOrganizationAction update_org = 5;
    }
```

## Transaction Header

### Inputs and Outputs

The inputs for Pike transactions must include:

* The address of the agent or organization being modified
* The address of the admin agent (agent correlating to the signing key)

The outputs for Pike transactions must include:

* The address of the agent or organization being modified
* If creating an organization, the address of the agent that will be created as
  admin

### Dependencies

None

### Family

- `family_name`: `"pike"`
- `family_version`: `"0.1"`

**Note**: The terms family, `family_name`, and `family_version` are a legacy
of the previous name for a smart contract, "transaction family".

## Execution

One of the following actions is performed while applying the transaction:

### CREATE_AGENT

This operation adds a new agent into Global State. Only another agent that
holds an admin role for the included organization may create an agent.

```protobuf
    message CreateAgentAction {
        string org_id = 1;
        string public_key = 2;
        bool active = 3;
        repeated string roles = 4;
        repeated KeyValueEntry metadata = 5;
    }
```

### UPDATE_AGENT

This operation updates the roles, metadata, and active status of an
existing agent stored in Global State. Only another agent that holds an
admin role for the included organization may update an agent. An agent
cannot remove the admin role from themselves.

```protobuf
    message UpdateAgentAction {
        string org_id = 1;
        string public_key = 2;
        string active = 3;
        repeated string roles = 4;
        repeated KeyValueEntry metadata = 5;
    }
```

### CREATE_ORGANIZATION

This operation adds a new organization to the Global State. The id for each
organization must be unique and cannot be changed once the organization is
created. The public key used to sign the transaction will
automatically be added as an new agent with the admin role.

```protobuf
    message CreateOrganizationAction {
        string id = 1;
        string name = 2;
        string address = 3;
        repeated KeyValueEntry metadata = 4;
    }
```

### UPDATE_ORGANIZATION

This operation updates the name and address of an existing organization
stored in Global State. Only an agent that holds an admin role for the
included organization may update the organization.

```protobuf
    message UpdateOrganizationAction {
        string id = 1;
        string name = 2;
        string address = 3;
        repeated KeyValueEntry metadata = 4;
    }
```

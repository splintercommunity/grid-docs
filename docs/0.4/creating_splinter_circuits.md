# Creating Splinter Circuits

<!--
  Copyright (c) 2024 Bitwise IO, Inc.
  Copyright (c) 2018-2022 Cargill Incorporated
  Licensed under Creative Commons Attribution 4.0 International License
  https://creativecommons.org/licenses/by/4.0/
-->

This procedure summarizes how to create a simple Splinter circuit between
two or more nodes, using the example Grid-on-Splinter environment that is
defined by
[grid/examples/splinter/docker-compose.yaml](https://github.com/splintercommunity/grid/blob/main/examples/splinter/docker-compose.yaml)
in the `grid` repository.

For more information on circuit creation, see [Creating a
Circuit](https://www.splinter.dev/docs/0.6/tutorials/configuring_splinter_nodes.html#creating-a-circuit)
in the Splinter documentation.

## Prerequisites

* Two or more working Grid nodes. See [Running Grid on
  Splinter](grid_on_splinter.md) for the procedure to set up and run Grid.
  The examples in this procedure shows two nodes, `alpha-node-000` and
  `beta-node-000`, that are running in Docker containers.

* A public/private key pair for the circuit administrator on each node. The
  keys are used to authorize requests sent to Splinter. This procedure uses
  the private key files `/registry/alpha.priv` (on `alpha-node-000`) and
  `/registry/beta.priv` (on `beta-node-000`). In this example, the key paths
  are saved by environment variables in the Splinter containers and also saved
  in the `allow_keys` file of the respective Splinter container to authorize
  the client to make requests.

* The full node ID (hostname and network endpoint) of each node that will
  belong to the circuit. This procedure shows
  `alpha-node-000::tcps://splinterd-alpha:8044` and
  `beta-node-000::tcps://splinterd-beta:8044`.

For more information, see the [Splinter documentation: Creating a
Circuit](https://www.splinter.dev/docs/0.6/tutorials/configuring_splinter_nodes.html#creating-a-circuit).
or the
[splinter-circuit-propose(1)](https://www.splinter.dev/docs/0.6/references/cli/splinter-circuit-propose.1.html)
man page.

## Important Notes

The examples in this procedure use the node hostnames, container names, node
IDs, and URLs that are defined in the example Grid-on-Splinter docker-compose
file, `examples/splinter/docker-compose.yaml`. If you are not using this example
environment, replace these items with the actual values for your nodes.

If not using the example's key files for Splinter, indicate the full path to
the private key of the user signing the transactions using the `--key` option
in Splinter commands. For more information on client authorization in
Splinter, see the [Splinter documentation](https://splinter.dev/docs/0.6/howto/configuring_rest_api_authorization.html).

Also, this procedure assumes that all nodes are running in docker containers on
the same system (as in the [example docker-compose
file](https://github.com/splintercommunity/grid/blob/main/examples/splinter/docker-compose.yaml)).
If the nodes are on separate physical systems, you must share node information
and network endpoints with the other administrators. To use the Splinter
registry to share node information, see the [Splinter
documentation](https://www.splinter.dev/docs/0.6/concepts/splinter_registry.html).

## Procedure

To create a circuit, a user on one node proposes a new circuit that includes one
or more other nodes. When users on the other nodes vote to accept the circuit
proposal, the circuit is created.

### Find the Grid Daemon Key

1. Get the gridd public key from the first node's `gridd` container (such as
   `gridd-alpha`).  You will need this key when proposing the circuit in a
   later step.

   ```
   $ docker exec gridd-alpha cat /etc/grid/keys/gridd.pub
   025011e5207e943aaf2181764bd4d8f921ce6da56ef0060dd06c90bcd44example
   ```

### Connect to the First Node

{:start="2"}

2. Connect to the first node's `splinterd` container (such as
   `splinterd-alpha`). You will use this container to run Splinter commands on
   the first node (for example, `alpha-node-000`).

   ```
   $ docker exec -it splinterd-alpha bash
   root@splinterd-alpha:/#
   ```

1. Copy the `gridd` public key from above and save it in a local file. Make
   sure to use your actual key value instead of the example value shown below.

   ```
   root@splinterd-alpha:/# echo "025011e5207e943aaf2181764bd4d8f921ce6da56ef0060dd06c90bcd44example" > gridd.pub
   ```

### Propose a New Circuit

{:start="4"}

4. Propose a new circuit with the `splinter circuit propose` command.

   ```
   root@splinterd-alpha:/# splinter circuit propose \
       --node alpha-node-000::tcps://splinterd-alpha:8044 \
       --node beta-node-000::tcps://splinterd-beta:8044 \
       --service gsAA::alpha-node-000 \
       --service gsBB::beta-node-000 \
       --service-type *::scabbard \
       --service-arg *::admin_keys=$(cat gridd.pub) \
       --service-peer-group gsAA,gsBB \
       --auth-type trust \
       --management grid
   ```

   For information on each option, see the
   [splinter-circuit-propose(1)](https://www.splinter.dev/docs/0.6/references/cli/splinter-circuit-propose.1.html)
   man page.

   **Note**: This command identifies the scabbard service on each node with a
   service ID (`gsAA` for alpha and `gsBB` for beta), plus the node's host name.
   Later, you will use this four-character service ID as part of the fully
   qualified service ID, which is required by `grid` commands for operations
   on the circuit.

1. Check the output to see the results of the transaction. If the proposal
   transaction succeeded, the output should resemble this example:

    ```
    The circuit proposal was submitted successfully
    Circuit: 01234-ABCDE
        Display Name: -
        Circuit Status: Active
        Schema Version: 2
        Management Type: grid

        alpha-node-000
            Endpoints:
                tcps://splinterd-alpha:8044
            Service (scabbard): gsAA
             admin_keys:
                 <gridd-alpha public key>
             peer_services:
                 gsBB

        beta-node-000
            Endpoints:
                tcps://splinterd-beta:8044
            Service (scabbard): gsBB
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsAA
    ```


1. Verify the results by displaying the list of proposals.

   ```
   root@splinterd-alpha:/# splinter circuit proposals
   ID          NAME MANAGEMENT MEMBERS                      COMMENTS PROPOSAL_TYPE
   01234-ABCDE -    grid       alpha-node-000;beta-node-000 -        Create
   ```

1. Set a `CIRCUIT_ID` environment variable based on the output of the
   `proposals` command.

   ```
   root@splinterd-alpha:/# export CIRCUIT_ID=01234-ABCDE
   ```

   **Note**: This environment variable is used to simplify the `splinter`
   commands in this procedure; it is not used directly by the `splinter` CLI.

1. Use the circuit ID to display the details of the proposed circuit.

    ```
    root@splinterd-alpha:/# splinter circuit show $CIRCUIT_ID
    Proposal to create: 01234-ABCDE
      Display Name: -
      Circuit Status: Active
      Schema Version: 2
      Management Type: grid

      alpha-node-000
          Vote: ACCEPT (implied as requester):
              <alpha-public-key>
          Endpoints:
              tcps://splinterd-alpha:8044
          Service (scabbard): gsAA
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsBB

      beta-node-000
          Vote: PENDING
          Endpoints:
              tcps://splinterd-beta:8044
          Service (scabbard): gsBB
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsAA
    ```

### Connect to the Second Node

A user on the other node (or nodes) must vote to accept or reject the circuit
proposal.

1. Connect to the second node's `splinterd` container (such as
   `splinterd-beta`). You will use this container to run Splinter commands on
   the second node (for example, on `beta-node-000`).

    ```
    $ docker exec -it splinterd-beta bash
    root@splinterd-beta:/#
    ```

### Vote on the Circuit Proposal

{:start="2"}

2. Find the ID of the proposed circuit. This ID is required for voting on the
   proposal and for interacting with the circuit once it is approved. For
   example:

    ```
    root@splinterd-beta:/# splinter circuit proposals
    ID          NAME MANAGEMENT MEMBERS                      COMMENTS PROPOSAL_TYPE
    01234-ABCDE -    grid       alpha-node-000;beta-node-000 -        Create
    ```

1. As on the first node, save the ID in the `CIRCUIT_ID` environment variable,
   which simplifies entering `splinter` commands.

    ```
    root@splinterd-beta:/# export CIRCUIT_ID=01234-ABCDE
    ```

1. Use the circuit ID to show the details of the proposed circuit.

    ```
    root@splinterd-alpha:/# splinter circuit show $CIRCUIT_ID
    Proposal to create: 01234-ABCDE
       Display Name: -
       Circuit Status: Active
       Schema Version: 2
       Management Type: grid

       alpha-node-000
           Vote: ACCEPT (implied as requester):
               <alpha-public-key>
           Endpoints:
               tcps://splinterd-alpha:8044
           Service (scabbard): gsAA
               admin_keys:
                   <gridd-alpha public key>
               peer_services:
                   gsBB

       beta-node-000
           Vote: PENDING
           Endpoints:
               tcps://splinterd-beta:8044
           Service (scabbard): gsBB
               admin_keys:
                   <gridd-alpha public key>
               peer_services:
                   gsAA
    ```

1. Vote to accept the proposal.

   ```
    root@splinterd-beta:/# splinter circuit vote \
       $CIRCUIT_ID \
       --accept
   ```

### Display the Circuit List and Circuit Details

{:start="6"}

6. Display all approved circuits to verify that the new circuit has been created.
   For example:

   ```
   root@splinterd-beta:/# splinter circuit list
   ID          NAME MANAGEMENT MEMBERS
   01234-ABCDE -    grid       alpha-node-000;beta-node-000
   ```

1. Check the circuit status on the first node. The circuit information should be
   the same on both nodes.

   ```
   root@splinterd-alpha:/# splinter circuit list
   ID          NAME MANAGEMENT MEMBERS
   01234-ABCDE -    grid       alpha-node-000;beta-node-000
   ```

1. You can display the circuit's details with the `splinter circuit show`
   command. This example uses the `CIRCUIT_ID` variable that was set in an
   earlier step.

    ```
    root@splinterd-alpha:/# splinter circuit show $CIRCUIT_ID
    Circuit: 01234-ABCDEg
        Display Name: -
        Circuit Status: Active
        Schema Version: 2
        Management Type: grid

        alpha-node-000
            Endpoints:
                tcps://splinterd-alpha:8044
            Service (scabbard): gsAA
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsBB

        beta-node-000
            Endpoints:
                tcps://splinterd-beta:8044
            Service (scabbard): gsBB
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsAA
    ```

   Now that the circuit has been accepted, note that the output starts with
   `Circuit:` instead of the `Proposal to create:` label that marks a proposed
   circuit (as shown in a previous step).

### Determine the Service ID

Most Grid commands require the fully qualified service ID for the scabbard
service on the circuit. This ID has the form
<code><i>circuitID</i>::<i>serviceString</i></code> (for example,
`01234-ABCDE::gsAA`). You can run `splinter circuit show` to see the elements
for the service ID, as shown in the previous step.

Tip: The `grid` CLI accepts the `GRID_SERVICE_ID` environment variable in place
of the `--service-id` option on the command line. For example, you can use the
following command to set this variable on `alpha-node-000`:

   ```
   root@gridd-alpha:/# export GRID_SERVICE_ID=01234-ABCDE::gsAA
   ```

For more information on `grid` commands, see the
[CLI command reference]({% link docs/0.4/cli_references.md %}).

## Next Steps

Now that you have a working circuit between member nodes, you can create items
such as Pike organizations, product schemas, and Grid products. For more
information, see
[Using Grid Features]({% link docs/0.4/using_grid_features.md %}).

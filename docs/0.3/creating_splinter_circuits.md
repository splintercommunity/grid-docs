# Creating Splinter Circuits

<!--
  Copyright (c) 2024 Bitwise IO, Inc.
  Copyright (c) 2019-2021 Cargill Incorporated
  Licensed under Creative Commons Attribution 4.0 International License
  https://creativecommons.org/licenses/by/4.0/
-->

This procedure summarizes how to create a simple Splinter circuit between
two or more nodes, using the example Grid-on-Splinter environment that is
defined by
[grid/examples/splinter/docker-compose.yaml](https://github.com/splintercommunity/grid/blob/main/examples/splinter/docker-compose.yaml)
in the `grid` repository.

For more information on circuit creation, see [Creating a
Circuit](https://www.splinter.dev/docs/0.4/tutorials/configuring_splinter_nodes.html#creating-a-circuit)
in the Splinter documentation.

## Prerequisites

* Two or more working Grid nodes. See [Running Grid on
  Splinter](grid_on_splinter.md) for the procedure to set up and run Grid.
  The examples in this procedure shows two nodes, `alpha-node-000` and
  `beta-node-000`, that are running in Docker containers.

* A public/private key pair for the circuit administrator on each node. The
  private keys are used to sign the transactions that propose a circuit (on the
  first node) and vote to accept the proposal (on the other nodes).
  This procedure shows the private key files `/registry/alpha.priv` (on
  `alpha-node-000`) and `/registry/beta.priv` (on `beta-node-000`).

  **Note**: If running Splinter 0.6, see the point below for how to authorize
  circuit administrators on each node.

* The URL of the Splinter REST API on the first node.  This procedure shows the
  URL `http://0.0.0.0:8085`.

* The full node ID (hostname and network endpoint) of each node that will
  belong to the circuit. This procedure shows
  `alpha-node-000::tcps://splinterd-alpha:8044` and
  `beta-node-000::tcps://splinterd-beta:8044`.

* If running Splinter 0.6, authorized Splinter users. 0.6 requires authorization
  for all interactions, which is not reflected in this tutorial as it is based
  on the example docker-compose environment running Splinter 0.4. A user may be
  authorized by adding their public key to Splinter's `allow_keys` file. This
  example requires the public keys used as the splinter service's admin key,
  the proposing node's `gridd.pub`, and as the circuit administrator, located in
  the `/registry` directory, be added to the `allow_keys` file for Splinter 0.6
  nodes. For more information on authorization in 0.6, see the [Splinter
  documentation](https://splinter.dev/docs/0.6/howto/configuring_rest_api_authorization.html).

For more information, see the [Splinter documentation: Creating a
Circuit](https://www.splinter.dev/docs/0.4/tutorials/configuring_splinter_nodes.html#creating-a-circuit).
or the
[splinter-circuit-propose(1)](https://www.splinter.dev/docs/0.4/references/cli/splinter-circuit-propose.1.html)
man page.

## Important Notes

The examples in this procedure use the node hostnames, container names, node
IDs, and URLs that are defined in the example Grid-on-Splinter docker-compose
file, `examples/splinter/docker-compose.yaml`. If you are not using this example
environment, replace these items with the actual values for your nodes.

Also, this procedure assumes that all nodes are running in docker containers on
the same system (as in the [example docker-compose
file](https://github.com/splintercommunity/grid/blob/main/examples/splinter/docker-compose.yaml).
If the nodes are on separate physical systems, you must share node information
and network endpoints with the other administrators. To use the Splinter
registry to share node information, see the [Splinter
documentation](https://www.splinter.dev/docs/0.4/concepts/splinter_registry.html).

Grid 0.3 supports both Splinter versions 0.4 and 0.6. As this procedure assumes
all nodes are running in docker containers based on the example Grid-on-Splinter
compose file, the Splinter commands are specific to version 0.4.

If your Splinter node is running 0.6, some commands have additional arguments
that must be added, noted below the affected tutorial step.

If either Splinter node is running 0.6, the commands for creating a circuit will
change depending on the version of Splinter used by the proposer. Altered
commands for creating a circuit between two Splinter nodes running either v0.4
or v0.6 are noted below the tutorial steps. For more information on creating a
circuit with version 0.6, see the [Splinter
documentation](https://www.splinter.dev/docs/0.6/references/cli/splinter-circuit-propose.1.html).

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

   For the `--key` option, specify the full path for the private key file of the
   user that should sign the vote transaction. This example uses the private key
   in `/registry/alpha.priv`.

   This command is valid if the proposing node (`splinterd-alpha` in this
   example) is running Splinter version 0.4.

   ```
   root@splinterd-alpha:/# splinter circuit propose \
      --key /registry/alpha.priv \
      --url http://splinterd-alpha:8085  \
      --node alpha-node-000::tcps://splinterd-alpha:8044 \
      --node beta-node-000::tcps://splinterd-beta:8044 \
      --service gsAA::alpha-node-000 \
      --service gsBB::beta-node-000 \
      --service-type *::scabbard \
      --management grid \
      --service-arg *::admin_keys=$(cat gridd.pub) \
      --service-peer-group gsAA,gsBB
   ```

   For information on each option, see the
   [splinter-circuit-propose(1)](https://www.splinter.dev/docs/0.4/references/cli/splinter-circuit-propose.1.html)
   man page.

   **Note**: This command identifies the scabbard service on each node with a
   service ID (`gsAA` for alpha and `gsBB` for beta), plus the node's host name.
   Later, you will use this four-character service ID as part of the fully
   qualified service ID, which is required by `grid` commands for operations
   on the circuit.

   **Note**: If both nodes are running Splinter 0.6, the circuit propose command
   will change as follows:

   ```
   root@splinterd-alpha:/# splinter circuit propose \
      --key /registry/alpha.priv \
      --url http://splinterd-alpha:8085 \
      --management grid \
      --auth-type trust \
      --node alpha-node-000::tcps://splinterd-alpha:8044 \
      --node beta-node-000::tcps://splinterd-beta:8044 \
      --service gsAA::alpha-node-000 \
      --service gsBB::beta-node-000 \
      --service-type *::scabbard \
      --service-arg *::admin_keys=$(cat gridd.pub) \
      --service-peer-group gsAA,gsBB
   ```

   **Note**: If the proposing node is running Splinter 0.6 and the receiving
   node is on Splinter 0.4, the circuit propose command will change as follows:

   ```
   root@splinterd-alpha:/# splinter circuit propose \
     --key /registry/alpha.priv \
     --url http://splinterd-alpha:8085 \
     --management grid \
     --compat 0.4 \
     --node alpha-node-000::tcps://splinterd-alpha:8044 \
     --node beta-node-000::tcps://splinterd-beta:8044 \
     --service gsAA::alpha-node-000 \
     --service gsBB::beta-node-000 \
     --service-type gsAA::scabbard \
     --service-type gsBB::scabbard \
     --service-peer-group gsAA,gsBB \
     --service-arg gsAA::admin_keys="[\"$(cat gridd.pub)\"]" \
     --service-arg gsBB::admin_keys="[\"$(cat gridd.pub)\"]"
   ```

   For information on each option in Splinter 0.6, see the
   [splinter-circuit-propose(1)](https://www.splinter.dev/docs/0.6/references/cli/splinter-circuit-propose.1.html)
   man page.

1. Check the output to see the results of the transaction. If the proposal
   transaction succeeded, the output should resemble this example:

   ```
   The circuit proposal was submitted successfully
   Circuit: 01234-ABCDE
       Management Type: grid

       alpha-node-000
           Service (scabbard): gsAA
             admin_keys:
                 <gridd-alpha public key>
             peer_services:
                 gsBB

       beta-node-000
           Service (scabbard): gsBB
             admin_keys:
                 <gridd-alpha public key>
             peer_services:
                 gsAA
   ```

   **Note**: If running Splinter 0.6, this output may change slightly. The main
   information should match the proposal, regardless.

1. Verify the results by displaying the list of proposals.

   ```
   root@splinterd-alpha:/# splinter circuit proposals --url http://splinterd-alpha:8085
   ID            MANAGEMENT MEMBERS                      COMMENTS
   01234-ABCDE   grid       alpha-node-000;beta-node-000
   ```

   **Note**: If running Splinter 0.6, add the `--key` argument to this command,
   pointing to the user's private key file.

   ```
   root@splinterd-alpha:/# splinter circuit proposals \
      --url http://splinterd-alpha:8085 \
      --key /registry/alpha.priv
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
   root@splinterd-alpha:/# splinter circuit show $CIRCUIT_ID --url http://splinterd-alpha:8085
   Proposal to create: 01234-ABCDE
      Management Type: grid

      alpha-node-000 (tcps://splinterd-alpha:8044)
          Vote: ACCEPT (implied as requester):
              <alpha-public-key>
          Service (scabbard): gsAA
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsBB

      beta-node-000 (tcps://splinterd-beta:8044)
          Vote: PENDING
          Service (scabbard): gsBB
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsAA
   ```

   **Note**: If running Splinter 0.6, add the `--key` argument to this command,
   pointing to the user's private key file. The output will also differ slightly
   from above.

   ```
   root@splinterd-alpha:/# splinter circuit show $CIRCUIT_ID \
      --url http://splinterd-alpha:8085 \
      --key /registry/alpha.priv
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
   root@splinterd-beta:/# splinter circuit proposals --url http://splinterd-beta:8085
   ID            MANAGEMENT MEMBERS                      COMMENTS
   01234-ABCDE   grid       alpha-node-000;beta-node-000
   ```

   **Note**: If running Splinter 0.6, add the `--key` argument to this command,
   pointing to the user's private key file.

   ```
   root@splinterd-beta:/# splinter circuit proposals \
      --url http://splinterd-beta:8085 \
      --key /registry/beta.priv
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
   root@splinterd-beta:/# splinter circuit show $CIRCUIT_ID --url http://splinterd-beta:8085
   Proposal to create: 01234-ABCDE
      Management Type: grid

      alpha-node-000 (tcps://splinterd-alpha:8044)
          Vote: ACCEPT (implied as requester):
              <alpha-public-key>
          Service (scabbard): gsAA
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsBB

      beta-node-000 (tcps://splinterd-beta:8044)
          Vote: PENDING
          Service (scabbard): gsBB
              admin_keys:
                  <gridd-alpha public key>
              peer_services:
                  gsAA
   ```

   **Note**: If running Splinter 0.6, add the `key` argument to this command,
   pointing to the user's private key file.

   ```
   root@splinterd-beta:/# splinter circuit show $CIRCUIT_ID \
      --url http://splinterd-beta:8085 \
      --key /registry/beta.priv
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

   For the `--key` option, specify the full path for the private key file of the
   user that should sign the vote transaction. This example uses the private key
   in `/registry/beta.priv`.

   ```
    root@splinterd-beta:/# splinter circuit vote \
       --key /registry/beta.priv \
       --url http://splinterd-beta:8085 \
       $CIRCUIT_ID \
       --accept
   ```

### Display the Circuit List and Circuit Details

{:start="6"}

6. Display all approved circuits to verify that the new circuit has been created.
   For example:

   ```
   root@splinterd-beta:/# splinter circuit list --url http://splinterd-beta:8085
   ID            MANAGEMENT MEMBERS
   01234-ABCDE   grid       alpha-node-000;beta-node-000
   ```

   **Note**: If running Splinter 0.6, add the `key` argument to this command,
   pointing to the user's private key file.

   ```
   root@splinterd-beta:/# splinter circuit list \
      --url http://splinterd-beta:8085 \
      --key /registry/beta.priv
   ID          NAME MANAGEMENT MEMBERS
   01234-ABCDE -    grid       alpha-node-000;beta-node-000
   ```

1. Check the circuit status on the first node. The circuit information should be
   the same on both nodes.

   ```
   root@splinterd-alpha:/# splinter circuit list --url http://splinterd-alpha:8085
   ID            MANAGEMENT MEMBERS
   01234-ABCDE   grid       alpha-node-000;beta-node-000
   ```

   **Note**: If running Splinter 0.6, add the `key` argument to this command,
   pointing to the user's private key file.

   ```
   root@splinterd-alpha:/# splinter circuit list \
      --url http://splinterd-alpha:8085 \
      --key /registry/alpha.priv
   ID          NAME MANAGEMENT MEMBERS
   01234-ABCDE -    grid       alpha-node-000;beta-node-000
   ```

1. You can display the circuit's details with the `splinter circuit show`
   command. This example uses the `CIRCUIT_ID` variable that was set in an
   earlier step.

   ```
   root@splinterd-alpha:/# splinter circuit show $CIRCUIT_ID --url http://splinterd-alpha:8085
   Circuit: 01234-ABCDE
       Management Type: grid

       alpha-node-000
           Service (scabbard): gsAA
             admin_keys:
                 02c6fd62b0940512eb7e081facc39f4f7aba65ef4e6234d00b127b80c2f5c30e5b
             peer_services:
                 gsBB

       beta-node-000
           Service (scabbard): gsBB
             admin_keys:
                 02c6fd62b0940512eb7e081facc39f4f7aba65ef4e6234d00b127b80c2f5c30e5b
             peer_services:
                 gsAA
   ```

   Now that the circuit has been accepted, note that the output starts with
   `Circuit:` instead of the `Proposal to create:` label that marks a proposed
   circuit (as shown in a previous step).

   **Note**: If running Splinter 0.6, add the `key` argument to this command,
   pointing to the user's private key file.

   ```
   root@splinterd-alpha:/# splinter circuit show $CIRCUIT_ID \
      --url http://splinterd-alpha:8085 \
      --key /registry/alpha.priv
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
[CLI command reference]({% link docs/0.3/cli_references.md %}).

## Next Steps

Now that you have a working circuit between member nodes, you can create items
such as Pike organizations, product schemas, and Grid products. For more
information, see
[Using Grid Features]({% link docs/0.3/using_grid_features.md %}).

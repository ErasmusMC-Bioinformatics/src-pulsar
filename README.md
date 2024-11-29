# Pulsar Node on SURF ResearchCloud

This repo provides the Ansible playbook for a [Pulsar](https://pulsar.readthedocs.io/) component on SURF ResearchCloud (SRC).

We have also written a short [step-by-step tutorial on how to use this role](./tutorial.md)

### Roles used

* The official [Pulsar Ansible role](https://github.com/galaxyproject/ansible-pulsar)
* Utility roles from the [UU SRC collection](https://github.com/UtrechtUniversity/researchcloud-items).

## Overview

### Services

* Pulsar is installed on the node
* Galaxy must later be configured to talk to this pulsar, please use the "Access" button once the node is up to see documentation on adding it to your Galaxy.

### ResearchCloud parameters

The component takes the following parameters:

* `pulsar_token`: CO-Secret. Please be sure to add a CO-Secret with the name `pulsar_token` in order to provide that secret value to the role. It may not be obvious if you haven't done this yet, please [see the documentation](https://servicedesk.surf.nl/wiki/display/WIKI/Secrets+and+workspace+info:+special+parameter+source+types#Secretsandworkspaceinfo:specialparametersourcetypes-Howtostoreasecrettoacollaboration) for more information.

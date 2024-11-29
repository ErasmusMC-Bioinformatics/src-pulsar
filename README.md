# Pulsar Node on SURF Research Cloud

This repo provides the Ansible playbook for a [Pulsar](https://pulsar.readthedocs.io/) component on SURF Research Cloud (SRC).

We have also written a short [step-by-step tutorial on how to use this role](./tutorial.md)

### Roles used

* The official [Pulsar Ansible role](https://github.com/galaxyproject/ansible-pulsar)
* Utility roles from the [UU SRC collection](https://github.com/UtrechtUniversity/researchcloud-items).

## Overview

### Services

* Pulsar is installed on the node
* Galaxy must later be configured to talk to this pulsar, please use the "Access" button once the node is up to see documentation on adding it to your Galaxy.

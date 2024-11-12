# Pulsar Node on SURF ResearchCloud

This repo provides the Ansible playbook for a [Pulsar](https://pulsar.readthedocs.io/) component on SURF ResearchCloud (SRC).

### Roles used

* The official [Pulsar Ansible role](https://github.com/galaxyproject/ansible-pulsar)
* Utility roles from the [UU SRC collection](https://github.com/UtrechtUniversity/researchcloud-items).

## Overview

### Services

* Pulsar is installed on the node
* Galaxy must later be configured to talk to this pulsar.

### ResearchCloud parameters

The component takes the following parameters:

* `src_galaxy_version`: String. Set to e.g. `23.2` (default) to control the version of Galaxy that will be installed.
(todo)

If you attach additional networked storage to the workspace, you can set `src_galaxy_storage_path` to a path on that storage volume. If your storage is e.g. called "galaxy storage", set the parameter to: `/data/galaxy_storage/datadir`. In theory, this should allow you to re-use datasets, tools, etc. from previous Galaxy workspaces.

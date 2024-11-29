---
title: How to run a Pulsar in SURF Research Cloud
author: hexylena
date: 2024-11-29
license: GPL-2.1
---

# Pulsar Node on SURF Research Cloud

This repo provides the Ansible playbook for a [Pulsar](https://pulsar.readthedocs.io/) component on SURF Research Cloud (SRC).

## How To


images/surf1.png
images/surf2.png
images/surf3.png
images/surf4.png
images/surf5.png
images/surf6.png
images/surf7.png
images/surf8.png
images/surf9.png
images/surf10.png









```diff
 runners:
   local:
     load: galaxy.jobs.runners.local:LocalJobRunner
     workers: 4
   condor:
     load: galaxy.jobs.runners.condor:CondorJobRunner
+  pulsar:
+    load: galaxy.jobs.runners.pulsar:PulsarRESTJobRunner
 
 
 # Uncomment if dynamic handlers are defined in "gravity:handlers" section in galaxy.yml
 #
 handling:
   assign:
   - db-skip-locked
 
 execution:
   default: docker_dispatch
   environments:
     local_destination:
       runner: local
 
     # ... probably some more runners here.
 
+    remote_p20:
+       runner: pulsar
+       url: https://p20.src-sensitive-i.src.surf-hosted.nl
+       private_token: ySgfM1rnGIsiVN8XlfkFhTB5kgp7AZm3jDnd
+       dependency_resolution: remote
+       manager: _default_
+       # Uncomment the following to enable interactive tools:
+       docker_enabled: true
+       docker_set_user: null
+       docker_memory: "8G"
+       singularity_enabled: false
+       tmp_dir: true
+       outputs_to_working_directory: false
+       container_resolvers:
+       - type: explicit
+       require_container: True
+       container_monitor_command: /mnt/pulsar/venv/bin/galaxy-container-monitor
+       container_monitor_result: callback
+       container_monitor_get_ip_method: command:echo p20.src-sensitive-i.src.surf-hosted.nl
 
 
 tools:
 - class: local # these special tools that aren't parameterized for remote execution - expression tools, upload, etc
   environment: local_env
 - id: Cut1
   environment: condor_1x1
+- id: interactive_tool_jupyter_notebook
+  environment: remote_p20
+- id: interactive_tool_rstudio
+  environment: remote_p20
```



## License

GPL-2

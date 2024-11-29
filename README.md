---
title: How to run a Pulsar in SURF Research Cloud
author: hexylena
date: 2024-11-29
license: GPL-2.1
---

# Pulsar Node on SURF Research Cloud

This repository provides the Ansible playbook for a [Pulsar](https://pulsar.readthedocs.io/) component on SURF Research Cloud (SRC), and serves as the primary documentation for using this Catalog Item.


## Catalog Item Tutorial


![A profile for Helena Rasche is shown with a public ssh key fingerprint and a button for changing the ssh keys in the profile.](images/surf9.png)

![screenshot of SRC login portal with a bright yellow login button](images/surf1.png)
![SRC dashboard, options like create new workspace, storage, or request a new wallet are available. three workspaces are listed: galaxy-test, imaging, and p20 in various states of running.](images/surf2.png)
![A small plus button is hovered over which says Add. Below galaxy-test is shown running with a yellow Access button](images/surf3.png)
![the two pulsar components in SRC: Galaxy Pulsar GPU Node (CUDA) and Galaxy Pulsar Node are shown. The second is expanded showing an author, Helena Rasche, and a description: let's you run galaxy jobs on another node](images/surf4.png)
![workspace creation screen, choose the cloud provider is locked to SURF HPC, flavour is locked to 22.04, and the size options are available from 1GB/8CPU to 60C/750GB Hi-mem](images/surf5.png)
![almost there! some final details reads this page, asking for name and description. both have been filled out with 'pulsar'. a yellow submit button waits at the bottom](images/surf6.png)
![workspace list showing a workspace named pulsar being created.](images/surf7.png)


access button:
![A small plus button is hovered over which says Add. Below galaxy-test is shown running with a yellow Access button](images/surf3.png)
![pulsar configuration information page showing an about with admins and metadata like workspace fqdn. Configuration for galaxy is shown below including XML changes](images/surf8.png)



> [!NOTE]  
> Highlights information that users should take into account, even when skimming.

> [!TIP]
> Optional information to help a user be more successful.

> [!IMPORTANT]  
> Crucial information necessary for users to succeed.

> [!WARNING]  
> Critical content demanding immediate user attention due to potential risks.

> [!CAUTION]
> Negative potential consequences of an action.






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

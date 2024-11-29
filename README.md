---
title: How to run a Pulsar in SURF Research Cloud
author: hexylena
date: 2024-11-29
license: GPL-2.1
---

# Pulsar Node on SURF Research Cloud

This repository provides the Ansible playbook for a [Pulsar](https://pulsar.readthedocs.io/) component on SURF Research Cloud (SRC), and serves as the primary documentation for using this Catalog Item.


## Using the Pulsar Catalog Item

### Authentication

<!-- ![A profile for Helena Rasche is shown with a public ssh key fingerprint and a button for changing the ssh keys in the profile.](images/surf9.png) -->

1. Ensure that you have an SSH key set in [your SRAM profile](https://sram.surf.nl/profile)
2. Make a note of your **username** from that page. It is probably of the format `ABBBBBB###` where A is your first initial and BBBBB is your last name, and potentially a number at the end.

### Creating a Pulsar Node

> [!NOTE]
> SSH access is required to reconfigure galaxy. Please make sure you set an SSH key

1. Log in to [SURF Research Cloud](https://portal.live.surfresearchcloud.nl/)

   ![screenshot of SRC login portal with a bright yellow login button](images/surf1.png)

2. In SRC, you should be in a collaborative organisation with a wallet. If you're not, I'm not sure how to fix that. I'm mostly writing this documentation for my colleagues in my CO. Mostly you can ignore the top half of the screen, only the bottom half is useful or relevant for us.

   ![SRC dashboard, options like create new workspace, storage, or request a new wallet are available. three workspaces are listed: galaxy-test, imaging, and p20 in various states of running.](images/surf2.png)

3. In the **Workspaces Tab** on the bottom half of the screen, you'll find a **Plus Button** at right to add a new workspace

   ![A small plus button is hovered over which says Add. Below galaxy-test is shown running with a yellow Access button](images/surf3.png)

4. Clicking that will let you choose any of the *Catalog Items* from SRC. They've got a wide selection but we're only interested in the two Pulsar Catalog Items

   ![the two pulsar components in SRC: Galaxy Pulsar GPU Node (CUDA) and Galaxy Pulsar Node are shown. The second is expanded showing an author, Helena Rasche, and a description: let's you run galaxy jobs on another node](images/surf4.png)

> [!WARNING]
> The GPU nodes are *expensive*. In fact it
> was the motivating reason for building this catalog item: to enable you to
> launch a node, run some computations, and shut it down, saving you money.

5. Creating a "workspace" (VM) from a catalog item (a template) is easy, most of the options are fixed for you, you just need to choose the size of the item. Pick an appropriate size for whatever computations you need to do.

   ![workspace creation screen, choose the cloud provider is locked to SURF HPC, flavour is locked to 22.04, and the size options are available from 1GB/8CPU to 60C/750GB Hi-mem](images/surf5.png)

6. Pick a name, it can be anything, it does not matter. Check the expiration date to ensure it is just enough time for your computation and no more. Click submit when you are happy.

> [!NOTE]
> By default an "Expiration date" of around 3 days later is chosen. This is an incredibly useful feature as it saves you from forgetting to destroy a VM. Especially for GPU nodes it can help you ensure that they disappear after your computation is complete.

   ![almost there! some final details reads this page, asking for name and description. both have been filled out with 'pulsar'. a yellow submit button waits at the bottom](images/surf6.png)

7. Once done, the workspace will be created for you. You'll need to wait ~5 minutes usually. Go for a beverage ☕️

   ![workspace list showing a workspace named pulsar being created.](images/surf7.png)

### Accessing the Pulsar Node

1. Once the workspace is up, you'll see an **Access** link:

   ![A small plus button is hovered over which says Add. Below galaxy-test is shown running with a yellow Access button](images/surf3.png)

2. Click that will show you a Pulsar information page. This page is running on your pulsar node itself, and is restricted to ensure only authorised members can access the contents. It includes some configuration you will need to copy to your Galaxy node in order to make use of the Pulsar node.

   ![pulsar configuration information page showing an about with admins and metadata like workspace fqdn. Configuration for galaxy is shown below including XML changes](images/surf8.png)


### Configuring Galaxy

The configuration is discussed fully in the Pulsar information, but it will be briefly covered here as well. Generally there are a few steps that must be followed:

- A runner must be registered 
- A destination/environment must be added with the pulsar details
- Some tools should be redirected to this Pulsar

Here is an example of what those changes look like in your Galaxy node.


```diff
 runners:
   local:
     load: galaxy.jobs.runners.local:LocalJobRunner
     workers: 4
   condor:
     load: galaxy.jobs.runners.condor:CondorJobRunner
+  pulsar:
+    load: galaxy.jobs.runners.pulsar:PulsarRESTJobRunner
 
 
 execution:
   default: docker_dispatch
   environments:
     local_destination:
       runner: local
 
     # ... probably some more environments here.
 
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

While you will simply copy-paste the runner and environment, you will need to identify yourself which tools should go to this Pulsar node.
If you have already run the tool that needs to go to the GPU node, you can find the ID from the job information page:
![job information page showing a tool id of interactive_tool_rstudio](./images/id1.png)

Otherwise, it can be found from the URL of a tool page, or from the dropdown to the left of "Execute" at the top of the tool:
![url bar and tool interface for the Cut1 tool](./images/id2.png)

> [!IMPORTANT]
> If you are running jobs for a limited period of time, you might consider making this pulsar node the default destination:
> 
> ```diff
>  execution:
> -  default: docker_dispatch
> +  default: remote_p20
>    environments:
>      local_destination:
>        runner: local
> ```

With that, you're done, and for the length of time your node is running, your chosen tools (or everything) will be executed on that Pulsar node with more memory and CPU than the Galaxy host, and maybe a GPU as well!

## License

GPL-2

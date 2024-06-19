# The HomeLab's Custom Linux Containers Inventory

An actively maintained listing of customized LXC images

This project aim is to build and share many LXC images for use on Proxmox Virtual Environments (or any other environments supporting LXCs).

Lets avoid **over-containerization** (Docker/Postman in LXC) and **over-virtualization** (Docker/Postman on vms).

Lets simply use native LXCs instead.

All images available here are generated using [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest) along with dedicated YAML definitions files.

The build themselves can be seen in this repo's actions.
Images are generated and shared in an object store accessible via [the listing website](https://lxc-images.soubilabs.xyz/).

This started as a personal project built for my own needs, then shared because it could help someone else (hopefully..).

## Your favorite application is missing here ?

Open an issue to submit the application details and we will try to add it as soon as possible.

## Contributions

It is very straight forward to add a new build template:

- Create a distrobuilder template

   - check the `templates/` directory to see some examples of already existing builds
   - check the [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) docs about how to use the keys `files` and `actions`

- Create a job to build the LXC image (check the `.github/workflows/` to see some examples of already existing builds)

### Local test

[Step 1] Install requirements:

- [Install distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/howto/install/)
- [Install KCL](https://www.kcl-lang.io/docs/user_docs/getting-started/install)
- [Install yq](https://mikefarah.gitbook.io/yq#install)

[Step 2] Create your LXC template (checck the `templates/` directory to see the already existing examples)

[ Step 3] Run the following commands

```sh {"id":"01J0MNYBZ7PPTE87YJCNJPC101"}
# Your template should be in the ./templates directory
read -p "Your template filename: " filename && yq eval '. as $root | {"kcl_options": [{"key": "build-instructions", "value": $root}]}' ./templates/${filename} > _lxc-partial.yml && echo "_lxc-partial.yml has been successfully generated !"
ls -lash ./_lxc-partial.yml
```

```sh {"id":"01J0MPD5W78R3GD6JKZRV9WHHS"}
# Render to final LXC template
kcl ./templates/__debian_base.k -Y _lxc-partial.yml > _lxc-template.yml && echo "_lxc-template.yml has been successfully generated !"
ls -lash ./_lxc-template.yml
```

Check the content of `_lxc-template` file to verify all is as expected. It should contains the conplete configuration (based on `./templates/__debian_base.k`)

```sh {"excludeFromRunAll":"false","id":"01J0MPGBG024BTJHTE54YMJP97"}
# Build your LXC image
# Do not work if exected into a container
read -p "Enter the application version to build: " version && distrobuilder build-lxc _lxc-template.yml -o image.architecture=amd64 -o image.release=bookworm -o image.serial="${version}" -o source.url="http://ftp.us.debian.org/debian"
```

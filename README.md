# The HomeLab's Custom Linux Containers Inventory

An actively maintained listing of customized LXC images

This project aim is to build and share many LXC images for use on Proxmox Virtual Environments (or any other environments supporting LXCs).

Lets avoid **over-containerization** (Docker/Postman in LXC) and **over-virtualization** (Docker/Postman on vms). Lets simply use native LXCs instead.

All images available here are generated using [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest) along with dedicated YAML definitions files.

The build themselves can be seen in this repo's actions.
Images are generated and shared in an object store accessible via [the listing website](https://lxc-images.soubilabs.xyz/).

This started as a personal project built for my own needs, then shared because it could help someone else (hopefully..).

## Your favorite application is missing here ?

Open an issue to submit the application details and we will try to add it as soon as possible.

## Contributions

It is very straight forward to add a new build template:

- Create a distrobuilder template (check the `templates/` directory to see some examples of already existing builds)
- create a job to build the LXC image (check the `.github/workflows/` to see some examples of already existing builds)

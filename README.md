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

- Create a [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) template

   - check the `templates/` directory to see some examples of already existing builds (you can take the template `templates/apisix.yml` as a solid example).
   - check the [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) docs about how to use the keys `files` and `actions` to see all possibilities available to you. Only both are using [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) directly. Other keys like `repositories` and `packages` are preprocessed before to be used by [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) but are pretty easy to use.

- Create a job to build the LXC image (check the `.github/workflows/` to see some examples of already existing builds)

### Local test

[Step 1] Install requirements:

- [Install distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/howto/install/)
- [Install KCL](https://www.kcl-lang.io/docs/user_docs/getting-started/install)
- [Install yq](https://mikefarah.gitbook.io/yq#install)

[Step 2] Create your LXC template (checck the `templates/` directory to see the already existing examples)

> Note: the base template already has some packages in its definition so you don't need to add them twice, those packages are: fuse, openssh-server, lsb-release, openssl, cloud-init, curl, wget, gpg, vim

[ Step 3] Run the following commands

```sh {"id":"01J0MNYBZ7PPTE87YJCNJPC101"}
# Your template should be in the ./templates directory
# Uses myapp.yml as default value. This file do not really exists!
read -p "Your template filename [myapp.yml]: " template_file && yq eval '. as $root | {"kcl_options": [{"key": "build-instructions", "value": $root}]}' ./templates/${template_file:-'myapp.yml'} > _lxc-partial.yml && echo "_lxc-partial.yml has been successfully generated !"
ls -lash ./_lxc-partial.yml
```

```sh {"id":"01J0MPD5W78R3GD6JKZRV9WHHS"}
# Render to final LXC template
kcl ./templates/__debian_base.k -Y _lxc-partial.yml > _lxc-template.yml && echo "_lxc-template.yml has been successfully generated !"
ls -lash ./_lxc-template.yml
```

Check the content of `_lxc-template` file to verify all is as expected. It should contains the conplete configuration (based on `./templates/__debian_base.k`)

```sh {"excludeFromRunAll":"true","id":"01J0MPGBG024BTJHTE54YMJP97"}
# Build your LXC image
# Do not work if exected into a container
# Uses 1.0.0 as default value
# This will raise an error if you use the image.serial variable in your template while your application do not have any 1.0.0 version
read -p "Enter the application version to build [1.0.0]: " version && distrobuilder build-lxc _lxc-template.yml -o image.architecture=amd64 -o image.release=bookworm -o image.serial="${version:-'1.0.0'}" -o source.url="http://ftp.us.debian.org/debian"
```

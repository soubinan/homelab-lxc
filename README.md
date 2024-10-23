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

[Open an issue](https://github.com/soubinan/homelab-lxc/issues/new?assignees=&labels=&projects=&template=new-application-request.md&title=Add+%3Capplication_name%3E+template) to submit the application details and we will try to add it as soon as possible.

## Contributions

It is very straight forward to add a new build template:

- Create a [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) template

   - Check the `templates/` directory to see some examples of already existing builds (you can take the template `templates/apisix.yml` as a solid example).
   - Check the [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) docs about how to use the keys `files` and `actions` to see all possibilities available to you. Only both are using [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) directly. Other keys like `repositories` and `packages` are preprocessed before to be used by [distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/) but are pretty easy to use (again `templates/apisix.yml` is a good example about how it works).
   - Give the metadata info below (all fields are required)
      - name (str)
      - get_version_command (str)
      - description (str)
      - categories (str)
      - project_source (str)
      - distribution (str)
      - release (str)
      - architectures (list)
   - Name your file according to the application name
   - That it, the automation will do the rest !

### Local test

[Step 1] Install requirements:

- [Install distrobuilder](https://linuxcontainers.org/distrobuilder/docs/latest/howto/install/)
- [Install KCL](https://www.kcl-lang.io/docs/user_docs/getting-started/install)
- [Install yq](https://mikefarah.gitbook.io/yq#install) (optional)
- [Install jq](https://jqlang.github.io/jq/download/) (optional)

[Step 2] [Create your LXC template](#contributions) (check the `templates/` directory to see the already existing examples) or select an existing one

> Note: the base template already has some packages in its definition so you don't need to add them twice, those packages are:
> * fuse
> * openssh-server
> * lsb-release
> * openssl
> * ca-certificates
> * apt-transport-https
> * cloud-init
> * curl
> * wget
> * gnupg2
> * gzip
> * vim
> * software-properties-common
> * tzdata
>

[ Step 3] Run the following command to build the final LXC template

```sh {"id":"01J0MPD5W78R3GD6JKZRV9WHHS"}
# Render to final LXC template
kcl run __layout.k -D input=templates/<template_filename>.yml > _lxc-template.yml

# ie: kcl run __layout.k -D input=templates/apisix.yml > apisix-template.yml
```

Check the content of `_lxc-template` file to verify all is as expected. It should contains the conplete configuration (based on `__layout.k` and the application specific inputs.)

```sh {"excludeFromRunAll":"true","id":"01J0MPGBG024BTJHTE54YMJP97"}
# Build your LXC image
# Do not work if executed into a container (need chroot)
sudo distrobuilder build-lxc _lxc-template.yml -o image.architecture=amd64 -o image.serial="<application version>"

# ie: sudo distrobuilder build-lxc apisix-template.yml -o image.architecture=amd64 -o image.serial="3.8.0"
```

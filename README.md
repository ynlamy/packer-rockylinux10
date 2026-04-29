# packer-rockylinux10

Creating a virtual machine template under [Rocky Linux 10](https://rockylinux.org/) from ISO file with [Packer](https://developer.hashicorp.com/packer/) using [VMware Workstation](https://www.vmware.com/). 

This was created by Yoann LAMY under the terms of the [GNU General Public License v3](http://www.gnu.org/licenses/gpl.html).

### Usage

This virtual machine template must be builded using Packer.

- ``cd packer-rockylinux10``
- ``packer init vmware-iso-rockylinux10.pkr.hcl``
- ``packer build vmware-iso-rockylinux10.pkr.hcl``

This template uses the **root** user with the password **MotDePasse**.

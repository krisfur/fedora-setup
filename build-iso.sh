#!/bin/sh
# Builds fedora-setup.iso: the netinstall ISO with ks.cfg embedded. Needs podman
# or docker. For a new Fedora release, update these values from its CHECKSUM.
set -eu
cd "$(dirname "$0")"
release=44
iso=Fedora-Everything-netinst-x86_64-44-1.7.iso
sha256=bd285201494dd0ba09b54d05ac707de1401668b8512a573edb5922dcf9d7067e

if [ ! -f "$iso" ]; then
  curl -fL -o "$iso.part" "https://dl.fedoraproject.org/pub/fedora/linux/releases/$release/Everything/x86_64/iso/$iso"
  mv "$iso.part" "$iso"
fi
echo "$sha256  $iso" | sha256sum -c -

engine=$(command -v podman || command -v docker)
"$engine" run --rm --privileged -v "$PWD:/work" -w /work "registry.fedoraproject.org/fedora:$release" sh -c "
  dnf -y -q install lorax &&
  rm -f fedora-setup.iso &&
  mkksiso --ks ks.cfg $iso fedora-setup.iso &&
  chown $(id -u):$(id -g) fedora-setup.iso"
echo "Built $PWD/fedora-setup.iso"

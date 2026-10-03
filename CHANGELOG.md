# Changelog

All notable changes to this collection will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this collection adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.1.1] - 2026-10-03

### Fixed

- Removed the "Ensure SDDM themes are present" task. Its source directory
  `files/usr/share/sddm/themes/` was empty, so git never tracked it and the
  role failed with "Could not find or access" when installed from the git tag
  or Galaxy tarball. Only a working-tree checkout with the empty directory
  ever worked.

## [1.1.0] - 2026-10-03

### Added

- `hyprland_home_dir`, `hyprland_manage_copr`, `hyprland_manage_services` so the
  `hyprland` role can run inside a bootc image build (skel mode).
- `~/.config/hypr/local.conf`, created once and sourced last by `hyprland.conf`,
  for per-machine overrides.
- Molecule scenario `skel` covering the image-build mode.
- Packages the shipped `hyprland.conf` already autostarts: swaybg, cliphist,
  network-manager-applet, gnome-keyring, xdg-desktop-portal-gtk,
  xdg-desktop-portal-hyprland, qt6ct, qt5-qtwayland, qt6-qtwayland; and the
  X11 SDDM greeter (sddm-x11).

### Changed

- Supported platforms: Fedora 42, 43, 44.
- The role installs `python3-dnf` before enabling the COPR: the
  `community.general.copr` module needs the dnf4 Python bindings, which
  dnf5-only Fedora hosts no longer ship by default.

### Fixed

- Molecule: scenarios now pass their inventory explicitly (molecule 26 stopped
  auto-loading `molecule/<scenario>/inventory/`), and the default scenario runs
  on `quay.io/fedora/fedora-bootc:44` because `fedora:42` has no `/sbin/init`.
  Previously every play skipped with "no hosts matched" and the scenario
  passed vacuously.

### Removed

- Packages picom (X11-only), flameshot (grim+slurp cover it), fish (shell is
  elvish), nwg-dock-hyprland (not packaged for Fedora 44). The dock's
  `exec-once` lines are commented out.

## [1.0.1] - 2026-05-28

### Changed

- Relicensed from GPL-2.0-or-later to MIT.
- Regenerated the collection + `hyprland` role README to the standardized house style.

## [1.0.0] - 2026-05-01

### Added

- Initial release of `danmwallace.fedora`.
- `hyprland` role for configuring the Hyprland desktop environment on Fedora.

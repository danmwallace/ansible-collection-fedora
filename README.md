# Ansible Collection — danmwallace.fedora

Roles for configuring Fedora workstation and atomic-variant desktops. The collection
centres on a Wayland-first desktop experience: it installs and themes
[Hyprland](https://hyprland.org/) together with its supporting toolchain (SDDM, Waybar,
Alacritty, Wofi, nwg-drawer) and renders a coherent, themed set of user dotfiles. It is
part of Dan's homelab automation and is consumed by the `ansible-homelab-cfg` control repo.

## Requirements

- Ansible >= 2.16
- Target host running Fedora (41, 42, or 43)
- Collection dependencies (from `galaxy.yml`):
  - `community.general >= 8.0.0` (for the `copr` module used by the `hyprland` role)
- Privilege escalation (`become: true`) on the target — roles install system packages,
  enable services, and adjust the default systemd target

## Installation

```bash
ansible-galaxy collection install danmwallace.fedora
```

Or pin it in `requirements.yml`:

```yaml
collections:
  - name: danmwallace.fedora
    version: ">=1.0.0"
```

## Roles

| Role | Description |
| --- | --- |
| [`danmwallace.fedora.hyprland`](roles/hyprland/README.md) | Install and configure the Hyprland tiling Wayland compositor on Fedora. |

## Example Playbook

```yaml
- name: Set up a Hyprland workstation
  hosts: workstations
  become: true
  roles:
    - role: danmwallace.fedora.hyprland
      vars:
        hyprland_user: dwallace
        hyprland_theme: tokyo-night
```

## License

MIT

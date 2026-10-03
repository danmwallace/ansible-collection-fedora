# danmwallace.fedora.hyprland

Install and configure the Hyprland tiling Wayland compositor on Fedora, along with a
curated set of supporting desktop tools (SDDM, Waybar, Alacritty, Wofi, nwg-drawer)
and a themed set of user dotfiles.

## Requirements

- Ansible >= 2.16
- Target host running Fedora (42, 43, or 44)
- `community.general` collection (for the `copr` module). The role installs
  `python3-dnf` first because that module needs the dnf4 Python bindings.
- A pre-existing local user account on the target — the role does not create users
- Privilege escalation (`become: true`) — installs system packages, enables `sddm`,
  and switches the default systemd target to `graphical.target`

The role enables the `lionheartp/Hyprland` COPR repository and installs from it.

## Role Variables

| Name                       | Type | Required | Default                              | Description                                                                                     |
|----------------------------|------|----------|--------------------------------------|-------------------------------------------------------------------------------------------------|
| `hyprland_user`            | str  | no       | `{{ ansible_facts['env']['USER'] }}` | Local user that owns the rendered dotfiles under `/home/<user>/.config/`.                       |
| `hyprland_theme`           | str  | no       | `nord`                               | Theme palette. One of: `monochrome`, `nord`, `tokyo-night`.                                     |
| `hyprland_home_dir`        | str  | no       | `/home/{{ hyprland_user }}`          | Directory that receives `.config/`. Use `/etc/skel` for image builds (files become root-owned). |
| `hyprland_manage_copr`     | bool | no       | `true`                               | Enable the `lionheartp/Hyprland` COPR. Set `false` if the caller already did.                   |
| `hyprland_manage_services` | bool | no       | `true`                               | Enable/start `sddm` and set `graphical.target`. Set `false` without a running systemd.          |

The `hyprland_theme` value selects a palette file under `vars/themes/<theme>.yml`,
which exposes the `hyprland_palette` dict consumed by the role's Jinja templates.

The `hyprland_user` default reads `$USER` on the controller, which is rarely the
right value for a remote host. Override it explicitly in production.

## Dependencies

None.

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

Inside a container or bootc image build (no systemd running, COPR enabled by dnf):

```yaml
- hosts: localhost
  connection: local
  roles:
    - role: danmwallace.fedora.hyprland
      vars:
        hyprland_user: root
        hyprland_home_dir: /etc/skel
        hyprland_manage_copr: false
        hyprland_manage_services: false
```

## Testing

Two Molecule scenarios use the ansible-native delegated driver with podman:

- `default`: a systemd container (`quay.io/fedora/fedora-bootc:44`) exercising
  the full role, including enabling `sddm`.
- `skel`: a plain container mirroring an image build (`hyprland_home_dir: /etc/skel`,
  COPR enabled by `dnf`, services unmanaged).

Both install the large desktop package set, so allow several minutes each.

```bash
molecule test -s default
molecule test -s skel
```

## License

MIT

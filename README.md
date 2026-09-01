# homelab-docker-stacks

Docker Compose stack definitions for all LXCs in the homelab. One monorepo,
deployed selectively to each host via Git sparse-checkout.

## Layout

```
my-docker-stacks/
├── .gitignore              # **/data/, **/.env
└── [lxc-name]/
    ├── [service-name]/compose.yaml
    └── [service-name]/.env
```

- **Top-level directory = LXC.** Each LXC's clone only checks out its own
  directory (see below).
- **One compose file per service.** Stacks are bundled together only when
  Compose forces it (e.g. a shared network namespace) — not the case
  anywhere in this repo currently.
- **`data/` directories are git-ignored.** Runtime state lives on disk per
  host, never in the repo.
- **UID/GID convention:** `PUID=1005 / PGID=1005` (`svc-docker`) for
  everything by default; `PUID=4000 / PGID=4000` (`media`) only for stacks
  that bind-mount NAS media.

## Why mgmt is versioned here but not Dockhand-managed

`mgmt` (Dockhand + Pulse) is kept in this repo for consistency, but its
stacks are added to Dockhand as **Internal** stacks, not **Git** stacks with
auto-sync. Dockhand shouldn't redeploy itself (or the thing that monitors
it) via its own automation — if a bad change breaks Dockhand, there'd be
nothing running to notice or roll it back. Update `mgmt` stacks manually.

Every other LXC's stacks are intended to be managed as Git stacks in
Dockhand once that's set up.

## Setting up a new LXC

Clone without checking out anything, enable sparse-checkout, then select
only this host's directory:

```bash
git clone --no-checkout --filter=blob:none \
  git@github.com:jsahlen/homelab-docker-stacks.git /docker
cd /docker

git sparse-checkout init --cone
git sparse-checkout set <lxc-name>   # e.g. media

git checkout main
```

Day to day, it behaves like a normal repo — `git pull`, edit, `git commit`,
`git push`. Only `<lxc-name>/` exists in the working tree; other stacks stay
out of the way but are still in `.git` if ever needed.

**Adding a stack to this LXC later:**
```bash
git sparse-checkout add <another-stack-dir>
```

**Moving a stack off this LXC:**
```bash
git sparse-checkout set <remaining-stacks>
```
(Files vanish locally — safe, they're still in history and on whichever
host now checks them out. `docker compose down` and clean up `data/`
manually first, since it was never tracked by git.)

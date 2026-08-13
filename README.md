# Termux WireProxy

A lightweight WireGuard-over-SOCKS5 management wrapper for Termux.

Termux WireProxy provides a simple command-line interface (`twp`) for managing a WireProxy-based VPN SOCKS5 proxy connection on Android using Termux.

The goal of this project is to make WireProxy easier to install, configure, start, stop, monitor, and troubleshoot from a mobile Linux environment.

---

## Features

- Simple `twp` command interface
- Automatic WireProxy dependency installation
- Provider/profile management
- Start, stop, and restart WireProxy
- Process and connection health checks
- Active configuration display
- VPN exit IP verification
- Log viewing and follow mode
- Version reporting
- Separation of public project files and private VPN credentials

---

## Requirements

Before installing, you need:

- Android device
- Termux
- A WireGuard-compatible VPN configuration file

Termux WireProxy uses:

- **WireProxy** to create a local SOCKS5 proxy from a WireGuard connection.
- **WireGuard configuration files** provided by your VPN provider or your own WireGuard server.

Your WireGuard configuration file contains private information such as cryptographic keys and should never be shared publicly.

---

## Installation

### 1. Clone the repository

Install Git if needed:

```bash
pkg install git
```

Clone the project:

```bash
git clone https://github.com/UnB21/termux-wireproxy.git
```

Enter the project directory:

```bash
cd termux-wireproxy
```

If you cloned the repository using a different directory name, enter that directory instead.

Example:

```bash
cd termux-wireproxy-test
```

You can verify your current working directory at any time by running:

```bash
pwd
```

Example output:

```text
/data/data/com.termux/files/home/<your-project-directory>
```

---

### 2. Run the installer

Run:

```bash
./install.sh
```

The installer will:

- Verify that it is running inside Termux
- Install WireProxy if it is missing
- Make the `twp` command executable
- Create the Termux command shortcut

After installation, verify:

```bash
twp version
```

The version displayed should match the version in the project's `VERSION` file.

Run diagnostics:

```bash
twp doctor
```

---

## Understanding the Project Layout

After installation, all project files are stored inside the directory you cloned.

To see the project files, run:

```bash
ls
```

You should see folders similar to:

```text
bin
configs
lib
logs
providers
scripts
state
```

The most important directories are:

| Directory | Purpose |
|-----------|---------|
| `providers/` | Stores your private WireGuard configuration files |
| `configs/` | Project configuration files |
| `scripts/` | Internal scripts used by the `twp` command |
| `logs/` | WireProxy log files |
| `state/` | Runtime state information |

### Important security note

The `providers/`, `logs/`, and `state/` directories may contain sensitive or runtime information.

WireGuard profiles contain private cryptographic keys and are intentionally excluded from Git tracking.

The `state/` directory contains runtime-generated configuration and process information. It should not be committed to the repository.

All commands shown throughout this guide should be run from inside the project directory unless stated otherwise.

---

## First-Time Configuration

Termux WireProxy uses provider profiles.

A provider profile is a WireGuard configuration file stored inside the `providers` directory.

The expected layout is:

```text
providers/
└── provider-name/
    └── profile-name.conf
```

Example:

```text
providers/
└── proton/
    └── us.conf
```

The provider directory identifies the VPN provider or WireGuard server.

The profile filename identifies the specific WireGuard configuration.

---

## Adding a WireGuard Profile

A WireGuard profile is a configuration file supplied by your VPN provider or generated for your own WireGuard server.

The file usually has a `.conf` extension and contains information such as:

- Interface private key
- VPN address
- Server public key
- Server endpoint
- Allowed IP addresses

Example filename:

```text
us.conf
```

Create a directory for your VPN provider:

```bash
mkdir -p providers/proton
```

Verify that the directory was created:

```bash
ls providers
```

Expected output:

```text
proton
```

At this point, the provider directory exists but is empty.

Your WireGuard configuration file must be copied into that directory before it can be used.

Never upload your WireGuard configuration file to GitHub or share it publicly.

Your WireGuard profile contains private cryptographic keys and should be treated like a password.

---

## Getting a WireGuard Configuration File

Termux WireProxy requires a WireGuard client configuration file that connects to an existing WireGuard server.

There are two common ways to obtain one.

---

## Option 1: Use a VPN Provider (Recommended)

Many VPN providers allow downloading WireGuard configuration files from their account dashboard.

This is the easiest option because the provider already operates the WireGuard server.

You should download a WireGuard configuration intended for a WireGuard-compatible client.

The downloaded file will normally have a `.conf` extension.

---

## Option 2: Create Your Own WireGuard Server

If you want to host your own VPN server, you can generate WireGuard configurations using tools such as:

- Nixpoin WireGuard Config Generator
  https://nixpoin.com/wireguard-generator/

- ServerSpan WireGuard Generator
  https://www.serverspan.com/en/tools/wireguard

These tools can help generate WireGuard server or client configuration files.

You will still need:

- A VPS or server
- A public IP address
- A WireGuard server installation
- Proper server-side WireGuard configuration

A configuration generator does not create a VPN service by itself.

After generating your client configuration file, place it in:

```text
providers/<provider>/<profile>.conf
```

Example:

```text
providers/myserver/home.conf
```

Then activate it:

```bash
twp use myserver home.conf
```

Prefer tools that generate private keys locally and do not transmit private keys to third parties.

Review the privacy information of any configuration generator before trusting it with cryptographic material.

---

## Copying Your WireGuard Configuration into Termux

If you downloaded your WireGuard configuration using your Android web browser, it is usually saved in your Downloads folder.

To allow Termux to access Android storage, run:

```bash
termux-setup-storage
```

When prompted, grant the requested storage permission.

Your Downloads folder will then be available at:

```text
~/storage/downloads
```

List the downloaded files:

```bash
ls ~/storage/downloads
```

If your configuration file is named `us.conf`, copy it into your provider directory:

```bash
cp ~/storage/downloads/us.conf providers/proton/
```

Verify that it was copied successfully:

```bash
ls providers/proton
```

Expected output:

```text
us.conf
```

Your WireGuard configuration is now ready to be selected by Termux WireProxy.

### Recommended permissions

Because the profile contains a private key, restrict its permissions:

```bash
chmod 600 providers/proton/us.conf
```

Verify the permissions:

```bash
stat -c '%a %n' providers/proton/us.conf
```

Expected output:

```text
600 providers/proton/us.conf
```

---

## Available Providers

List available provider profiles:

```bash
twp providers
```

This command displays the provider directories and available profiles that Termux WireProxy can use.

---

## Selecting a Provider Profile

The `twp use` command expects two arguments:

```text
twp use <provider> <profile>
```

- `<provider>` is the name of the directory inside `providers/`
- `<profile>` is the name of the WireGuard configuration file

For example, if your project looks like this:

```text
providers/
└── proton/
    └── us.conf
```

Run:

```bash
twp use proton us.conf
```

Another example:

```text
providers/
└── myserver/
    └── home.conf
```

Run:

```bash
twp use myserver home.conf
```

After selecting a profile, verify the active configuration:

```bash
twp current
```

Run diagnostics:

```bash
twp doctor
```

---

## Quick Start Example

The following example demonstrates a complete first-time setup after installation.

Create a provider directory:

```bash
mkdir -p providers/myvpn
```

Copy your WireGuard configuration file into that directory:

```text
providers/myvpn/home.conf
```

Select the profile:

```bash
twp use myvpn home.conf
```

Verify the active configuration:

```bash
twp current
```

Run diagnostics:

```bash
twp doctor
```

Start WireProxy:

```bash
twp start
```

Check that WireProxy is running:

```bash
twp status
```

Run the health check:

```bash
twp health
```

Verify your VPN exit IP:

```bash
twp ip
```

If everything is configured correctly, the reported exit IP should correspond to the VPN connection rather than your normal network connection.

---

## Understanding the Runtime Configuration

Termux WireProxy does not require a static WireProxy configuration file to be stored in the repository.

When WireProxy is started, Termux WireProxy generates the active runtime configuration inside the `state/` directory.

For example:

```text
state/
└── wireproxy.conf
```

The runtime configuration is generated from the currently selected provider and profile.

A typical generated configuration looks similar to:

```text
WGConfig = /data/data/com.termux/files/home/termux-wireproxy/providers/proton/example.conf

[Socks5]
BindAddress = 127.0.0.1:25344
```

The exact path depends on your project location and selected provider profile.

### Why the runtime configuration is not tracked by Git

The generated runtime configuration contains the path to your private WireGuard profile.

Keeping the runtime configuration outside Git provides a cleaner separation between:

- Public project files
- Private WireGuard credentials
- Local user configuration
- Runtime state

The `state/` directory is therefore intentionally ignored by Git.

---

## Testing the Connection

Run:

```bash
twp health
```

The health check verifies important parts of the active connection, including:

- WireProxy process availability
- SOCKS5 proxy availability
- VPN exit IP availability

To check your VPN exit IP directly:

```bash
twp ip
```

A healthy connection should report an exit IP associated with the configured VPN connection.

---

## Commands

The `twp` command manages WireProxy without requiring you to manually run WireProxy commands.

### Start WireProxy

```bash
twp start
```

### Stop WireProxy

```bash
twp stop
```

### Restart WireProxy

```bash
twp restart
```

### Check Status

```bash
twp status
```

### Health Check

```bash
twp health
```

### Diagnose Problems

```bash
twp doctor
```

### Show Current Configuration

```bash
twp current
```

### Show VPN Exit IP

```bash
twp ip
```

### View Logs

```bash
twp logs
```

### Follow Logs

```bash
twp logs -f
```

### List Providers

```bash
twp providers
```

### Change Provider Profile

```bash
twp use <provider> <profile>
```

Example:

```bash
twp use proton us.conf
```

### Show Version

```bash
twp version
```

---

## Typical Command Workflow

After a profile has been configured, a normal workflow is:

```bash
twp current
twp doctor
twp start
twp status
twp health
twp ip
```

To stop the connection:

```bash
twp stop
```

To restart it:

```bash
twp restart
```

To investigate a problem:

```bash
twp doctor
twp status
twp logs
```

---

## Troubleshooting

### `twp: command not found`

Run the installer again:

```bash
./install.sh
```

Then verify:

```bash
twp version
```

If the command still cannot be found, verify that the Termux command directory is available:

```bash
echo "$PREFIX/bin"
```

You can also verify that the `twp` command exists:

```bash
ls -l "$PREFIX/bin/twp"
```

---

### WireProxy is missing

Run:

```bash
./install.sh
```

The installer will install WireProxy automatically if it is not already installed.

You can also verify manually:

```bash
wireproxy --version
```

---

### Provider profile missing

This usually means Termux WireProxy could not find the WireGuard configuration file it expects.

First, list your provider directories:

```bash
ls providers
```

Then list the profiles inside your provider directory:

```bash
ls providers/proton
```

Verify the currently selected configuration:

```bash
twp current
```

Run diagnostics:

```bash
twp doctor
```

If you selected the wrong provider or profile, activate the correct one:

```bash
twp use <provider> <profile>
```

Example:

```bash
twp use proton us.conf
```

---

### WireProxy will not start

Run:

```bash
twp doctor
```

Then check the logs:

```bash
twp logs
```

You can also check the current status:

```bash
twp status
```

Restart if needed:

```bash
twp restart
```

---

### SOCKS5 proxy unavailable

If `twp doctor` reports that SOCKS5 is unavailable:

Check status:

```bash
twp status
```

Review logs:

```bash
twp logs
```

Restart WireProxy:

```bash
twp restart
```

Then run the health check again:

```bash
twp health
```

---

### WireGuard profile permissions are incorrect

Run:

```bash
stat -c '%a %n' providers/proton/*.conf
```

Private WireGuard profiles should normally be restricted to the owner.

For example:

```bash
chmod 600 providers/proton/us.conf
```

Verify again:

```bash
stat -c '%a %n' providers/proton/us.conf
```

Expected:

```text
600 providers/proton/us.conf
```

You can also use:

```bash
twp doctor
```

The security diagnostics should report that the WireGuard profile permissions are protected.

---

### WireGuard profile is being tracked by Git

Never commit a private WireGuard profile.

Check whether Git is tracking any provider profiles:

```bash
git ls-files 'providers/**/*.conf'
```

A correctly protected repository should not list private WireGuard profiles.

Check the repository status:

```bash
git status --short
```

The `.gitignore` file intentionally excludes private provider configuration files.

---

## Security

Private files are intentionally excluded from Git tracking.

Ignored files include:

```text
providers/**/*.conf
configs/project.local.conf
logs/
state/
```

Never upload:

- WireGuard configuration files
- Private keys
- VPN credentials
- Runtime configuration files
- Other files containing secrets

Treat your WireGuard profile the same way you would treat a password.

### Git protection

The project uses Git ignore rules to help prevent private WireGuard profiles from being committed.

You should still verify Git status before committing changes:

```bash
git status --short
```

You can check tracked provider files with:

```bash
git ls-files 'providers/*'
```

Private `.conf` files should not appear in the tracked-file list.

### File permissions

Termux WireProxy's diagnostic system checks important file permissions.

Run:

```bash
twp doctor
```

A healthy security section should report protected permissions for:

- Project directory
- Provider directory
- WireGuard profile
- Local configuration
- Runtime configuration

---

## Repository Cleanup and Integrity Checks

If you are developing or modifying Termux WireProxy, you can inspect what Git is tracking with:

```bash
git ls-files
```

Check tracked configuration files:

```bash
git ls-files 'configs/*'
```

Check tracked provider files:

```bash
git ls-files 'providers/*'
```

Check ignored runtime files:

```bash
git status --short --ignored
```

Check the provider directory structure:

```bash
find providers -maxdepth 2 -type f -printf '%M %p\n' | sort
```

Check runtime state:

```bash
find state -maxdepth 1 -type f -printf '%M %p\n' | sort
```

Check the current runtime:

```bash
twp current
```

Check connection health:

```bash
twp health
```

Run the complete diagnostic system:

```bash
twp doctor
```

---

## Development

Termux WireProxy is designed to be developed directly from Termux.

The project separates:

```text
Public project files
        |
        +-- bin/
        +-- configs/
        +-- docs/
        +-- lib/
        +-- scripts/
        +-- README.md
        +-- LICENSE
        +-- VERSION

Private/local files
        |
        +-- providers/*.conf
        +-- configs/project.local.conf
        +-- logs/
        +-- state/
```

Private configuration and runtime data should remain local to the user's Termux environment.

Before committing changes, review:

```bash
git status
```

Then inspect the changes:

```bash
git diff
```

If changes are ready to commit:

```bash
git add -A
```

Review the staged changes:

```bash
git diff --cached
```

Only commit after verifying that no private credentials or runtime files are staged.

---

## Project Status

Current version:

```text
0.3.7
```

The authoritative project version is stored in:

```text
VERSION
```

You can check it with:

```bash
cat VERSION
```

You can also display the installed project version with:

```bash
twp version
```

This project is actively under development.

---

## License

This project is licensed under the MIT License.

See the [LICENSE](LICENSE) file for details.

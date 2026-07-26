# Termux WireProxy v2 Command Reference

## Purpose

This document defines the planned command structure for Termux WireProxy v2.

Commands are designed from the perspective of a new Termux user with little or no Linux experience.

The goal:

A user should be able to install, configure, diagnose, and operate Termux WireProxy using clear commands with understandable output.

---

# Command Overview

```
twp
├── init
├── start
├── stop
├── restart
├── status
├── health
├── doctor
├── providers
├── profiles
├── use
├── logs
└── version
```

---

# Setup Commands

## twp init

### Purpose

First-run setup wizard.

This is the primary improvement over v0.1.0-alpha.

The command should guide a new user through:

- dependency checks
- storage permission checks
- WireGuard configuration discovery
- provider/profile creation
- initial configuration generation
- connection validation

Example:

```
$ twp init

Termux WireProxy Setup Wizard

Checking environment...
✓ Termux detected
✓ wireproxy installed

Checking storage access...
✓ Shared storage available

Searching for WireGuard profiles...

Found:
1) us.conf
2) home.conf

Select profile:
```

After successful setup:

```
Setup complete.

Active profile:
proton / us.conf

Run:

twp start
```

---

# Runtime Commands

## twp start

### Purpose

Start WireProxy using the active configuration.

Responsibilities:

- validate configuration
- generate WireProxy configuration
- start process
- save PID information
- report SOCKS5 address

---

## twp stop

### Purpose

Stop the active WireProxy process.

Responsibilities:

- locate running process
- clean PID state
- confirm shutdown

---

## twp restart

### Purpose

Restart WireProxy.

Equivalent workflow:

```
stop
start
```

---

# Information Commands

## twp status

### Purpose

Display current operating state.

Should show:

- version
- active provider
- active profile
- process status
- SOCKS5 endpoint
- VPN exit IP

---

## twp health

### Purpose

Perform a live connection test.

Checks:

- WireProxy process
- SOCKS5 response
- external IP availability

---

## twp doctor

### Purpose

Troubleshooting assistant.

Designed for users reporting problems.

Checks:

- Termux environment
- dependencies
- permissions
- configuration
- profiles
- running processes
- network availability

---

# Provider Management

## twp providers

### Purpose

List available providers.

Example:

```
Available Providers

[proton]

  us.conf
  home.conf
```

---

## twp profiles

### Purpose

List available WireGuard profiles.

Future command.

Possible features:

- search profiles
- rename profiles
- remove profiles
- validate profiles

---

## twp use

### Purpose

Select the active provider/profile.

Example:

```
twp use proton us.conf
```

Changes:

```
Provider:
proton

Profile:
us.conf
```

---

# Logging

## twp logs

### Purpose

Display WireProxy logs.

Options:

Future support:

```
twp logs -f
```

for live monitoring.

---

# Information

## twp version

### Purpose

Display installed version.

Example:

```
Termux WireProxy

Version:
0.2.0-dev
```

---

# Design Principles

All commands should:

- provide clear output
- explain errors
- avoid unnecessary manual file editing
- protect sensitive configuration files
- work from any directory
- support troubleshooting without advanced Linux knowledge

---

# Future Goals

Possible future commands:

```
twp update
twp remove
twp backup
twp restore
twp export
twp import
```

These will be considered after the core v2 workflow is complete.

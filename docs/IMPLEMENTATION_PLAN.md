# Termux WireProxy v2 - Implementation Plan

## Purpose

This document defines the implementation strategy for Termux WireProxy v2.

The goal is to transform the alpha version from a working collection of scripts into a maintainable, automated, beginner-friendly application structure.

Implementation will prioritize:

- reliability
- simple user experience
- secure handling of VPN profiles
- clear troubleshooting
- maintainable code

---

# Development Strategy

v2 development will occur in stages.

Each stage should:

1. Be implemented separately
2. Be tested independently
3. Be documented
4. Be committed to Git

The stable alpha branch remains unchanged while v2 is developed on:

```
develop
```

---

# Phase 1 - Project Refactoring

## Goal

Prepare the project structure for future growth.

Current structure:

```
bin/
scripts/
lib/
configs/
providers/
```

Target structure:

```
bin/
└── twp

scripts/
├── init.sh
├── start.sh
├── stop.sh
├── restart.sh
├── status.sh
├── health.sh
├── doctor.sh
├── providers.sh
├── profiles.sh
├── use.sh
└── logs.sh

lib/
├── common.sh
├── storage.sh
├── profiles.sh
├── validation.sh
└── config.sh

configs/
├── project.conf
└── wireproxy.conf

providers/

docs/
```

---

# Phase 2 - Configuration System

## Goal

Remove hardcoded paths and make configuration portable.

Requirements:

- project works after cloning anywhere
- generated configuration uses active profile
- no user-specific paths stored permanently

Configuration sources:

```
project.conf
    |
    v
active provider
    |
    v
WireProxy configuration
```

---

# Phase 3 - Storage Detection

## Goal

Automatically locate user WireGuard profiles.

Create:

```
lib/storage.sh
```

Responsibilities:

- detect Termux storage availability
- explain missing permissions
- search common locations

Search locations:

```
~/storage/downloads
~/storage/shared/Download
/storage/*/Download
```

Search:

```
*.conf
```

---

# Phase 4 - Profile Management

## Goal

Create an automated provider/profile system.

Create:

```
lib/profiles.sh
```

Responsibilities:

- import profiles
- list profiles
- validate names
- prevent accidental overwrite

Example:

Input:

```
/storage/emulated/0/Download/us.conf
```

Output:

```
providers/user/us.conf
```

---

# Phase 5 - Validation Framework

## Goal

Provide reusable checks.

Create:

```
lib/validation.sh
```

Checks:

## Environment

- Termux detected
- required commands available

## WireGuard Profile

Check:

```
[Interface]

PrivateKey

[Peer]

Endpoint
```

## Runtime

Check:

- WireProxy process
- SOCKS5 proxy
- connectivity

---

# Phase 6 - Implement

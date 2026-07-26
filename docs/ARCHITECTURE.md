# Termux WireProxy Architecture

## Overview

Termux WireProxy is a lightweight WireGuard proxy management tool designed specifically for Android devices running Termux.

The project provides a simple command-line interface (`twp`) that manages WireProxy connections while hiding unnecessary complexity from users.

The primary design goal:

> A beginner should be able to establish a working connection without manually editing configuration files.

---

# Project Goals

## User Experience

The project should:

- require minimal manual configuration
- provide clear explanations
- detect common problems automatically
- provide useful error messages
- support beginners while remaining powerful for advanced users

---

# Core Components

## twp CLI

Location:

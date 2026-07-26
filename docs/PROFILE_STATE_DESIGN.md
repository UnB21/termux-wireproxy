# Termux WireProxy v2 - Profile State Design

## Purpose

This document defines how Termux WireProxy stores and manages the active WireGuard profile.

The goal is to remove the need for users to manually edit configuration files.

A new user should be able to:

1. Install Termux WireProxy
2. Run initialization
3. Select their WireGuard profile
4. Start the connection

The project should manage the active configuration automatically.

---

# Current Design Problem

The current workflow stores the active profile inside:

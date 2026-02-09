# Initial Setup Prompt

Copy and paste this as your first message to Claude Code on the Mac mini:

---

Read CLAUDE.md and QUICKSTART.md. This is a fresh Mac mini running macOS Tahoe 26.2 (Apple Silicon).

IMPORTANT: macOS Tahoe 26 was released September 2025 and may be past your training cutoff. Before starting, do a web search for "macOS Tahoe 26.2 known issues developer" and "MacPorts Tahoe problems" to catch any compatibility issues that affect our setup. Check https://trac.macports.org/wiki/TahoeProblems for MacPorts-specific breakage.

Key Tahoe facts you may not know:
- macOS Tahoe uses "Liquid Glass" design language (new transparency system)
- Launchpad was removed, replaced by "Apps"
- yabai is broken on Tahoe (that's why we use AeroSpace)
- Some system apps cannot be deleted (signed system volume)
- `launchctl bootout/disable` is the new way to manage services
- SIP-protected daemons cannot be unloaded (e.g. Spotlight mds)

Now run the full system setup:

1. Check if Xcode and MacPorts are installed (tell me if they're missing, I'll install them manually)
2. Run `./scripts/setup.sh` to install all packages and deploy all configs
3. Walk me through installing AeroSpace (Step 6 in macminisetup.md)
4. Run `./scripts/verify.sh` and fix anything that fails
5. Show me the final verification output

If any MacPorts package fails to build, skip it, note it, and continue with the rest. We'll fix failures after the core setup is done.

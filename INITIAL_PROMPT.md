# Initial Setup Prompt

Copy and paste this as your first message to Claude Code on the Mac mini:

---

Read CLAUDE.md and QUICKSTART.md. This is a fresh Mac mini running macOS Tahoe. Run the full system setup:

1. Check if Xcode and MacPorts are installed (tell me if they're missing, I'll install them manually)
2. Run `./scripts/setup.sh` to install all packages and deploy all configs
3. Walk me through installing AeroSpace (Step 6 in macminisetup.md)
4. Run `./scripts/verify.sh` and fix anything that fails
5. Show me the final verification output

If any MacPorts package fails to build, skip it, note it, and continue with the rest. We'll fix failures after the core setup is done.

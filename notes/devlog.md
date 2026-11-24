# Development Log

## 24 Nov 2026
- Chose project: Online Appointment Booking System
- Installed Node.js, Git, PostgreSQL 17 (winget msstore source failed with a certificate error, used --source winget)
- npm install failed with UNABLE_TO_VERIFY_LEAF_SIGNATURE (network intercepts HTTPS); fixed with NODE_USE_SYSTEM_CA=1
- Created Express server with /api/health endpoint
- First Render deploy failed (code not pushed, no package.json); fixed by committing and pushing
- Deployed live on Render over HTTPS

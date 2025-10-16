# Phase 1: Start from the official, minimal base image
FROM node:22-alpine

# Phase 2: Remediate known base-image vulnerabilities (CR-20251013-04)
RUN apk update && apk upgrade busybox

# Phase 3: Update tooling to secure versions (CR-20251013-06)
RUN npm install -g npm@latest

# Phase 4: Create a non-root user for improved security
RUN addgroup -S appgroup && adduser -S appuser -G appgroup
USER appuser

# Phase 5: Set up the project and install the tool
WORKDIR /home/appuser/gemini-project
COPY --chown=appuser:appgroup package.json .
RUN npm install

# Phase 6: SECURITY GATE - Run the audit.
RUN npm audit

# Phase 7: Set the final entrypoint for the CLI
ENTRYPOINT ["npx", "gemini"]

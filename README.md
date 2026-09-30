# bash-utils

A retained collection of Bash/operations scripts and runbooks accumulated across infrastructure, data engineering and web-hosting work.

## Repository status

This repository is a **utility/reference asset**, not a supported production automation package. Some scripts are still useful as starting points, while others document older operating environments and should be reviewed before execution.

Current material includes:

- Ubuntu/CentOS administration helpers
- Laravel/Apache/Nginx setup notes and scripts
- WordPress/Nginx setup automation
- file comparison and file-inspection utilities
- ETL/data-file helpers
- Spark/Scala environment setup notes
- server monitoring/smoke-test helpers
- Slack messaging examples
- assorted deployment/runtime snippets

## Safety and compatibility

Treat every script as source material rather than a guaranteed-current runbook.

Before running a script:

1. read it end-to-end;
2. replace placeholders with explicit environment/configuration values;
3. verify commands against the target operating system and package versions;
4. check filesystem permissions and destructive commands;
5. test in an isolated environment first;
6. never commit credentials, tokens, SSH keys or private endpoints.

Several files pre-date current package repositories and security practices. For example, older Java/Spark installation instructions and broad filesystem permission changes should not be copied into modern production provisioning without redesign.

## Modernisation direction

Useful scripts should gradually be promoted into small, documented, idempotent utilities with:

- `set -euo pipefail` where appropriate;
- shellcheck coverage;
- explicit arguments/environment contracts;
- safe defaults and dry-run modes for destructive work;
- current platform/package assumptions;
- examples and tests where practical.

Obsolete one-off snippets can remain as historical reference until a later archive/pruning pass determines that they have no reuse value.

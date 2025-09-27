# Set the default recipe to list all available commands
@default:
    @just --list

# Set the uv run command
uv := "uv run"

#Set the uv command to run a tool
uv-tool := "uv tool run"

# Run Ruff linking
@lint:
    {{uv-tool}} ruff check

# Run Ruff formatting
@format:
    {{uv-tool}} ruff format

# Sync the package
@sync:
    uv sync --all-extras

# Sync the package
@sync-up:
    uv sync --all-extras --upgrade

# Lock the package version
@lock:
    uv lock

# Build the package
@build:
    uv build

# Create a new GitHub release - this requires Python 3.11 or newer, and the GitHub CLI must be installed and configured
version := `echo "from tomllib import load; print(load(open('pyproject.toml', 'rb'))['project']['version'])" | uv run - `

[confirm("Are you sure you want to create a new release?\nThis will create a new GitHub release and will build and deploy a new version to PyPi.\nYou should have already updated the version number using one of the bump recipes.\nTo check the version number, run just version.\n\nCreate release?")]
@release:
    echo "Creating a new release for v{{version}}"
    git pull
    gh release create "v{{version}}" --generate-notes

@version:
    git pull
    echo {{version}}

# Upgrade pre-commit hooks
@pc-up:
    {{uv-tool}} pre-commit autoupdate

# Run pre-commit hooks
@pc-run:
    {{uv-tool}} pre-commit run --all-files

# Use BumpVer to increase the patch version number. Use just bump -d to view a dry-run.
@bump *ARGS:
    uv run bumpver update --patch {{ ARGS }}
    uv sync

# Use BumpVer to increase the minor version number. Use just bump -d to view a dry-run.
@bump-minor *ARGS:
    uv run bumpver update --minor {{ ARGS }}
    uv sync

# Use BumpVer to increase the major version number. Use just bump -d to view a dry-run.
@bump-major *ARGS:
    uv run bumpver update --major {{ ARGS }}
    uv sync

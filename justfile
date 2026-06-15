# Set the default recipe to list all available commands
@default:
    @just --list

# Synchronize the current working set with lock file
sync:
    pdm sync --clean

# Resolve and lock dependencies
lock:
    pdm lock --exclude-newer 7d

# Run the command line interface
@run *ARGS:
    pdm run djcheckup {{ ARGS }}

# Install pre-commit hooks
@pc-install:
    pdm run pre-commit install

# Upgrade pre-commit hooks
@pc-up:
    pre-commit autoupdate

# Run pre-commit hooks
@pc-run:
    pre-commit run --all-files

# Use BumpVer to increase the patch version number. Use just bump -d to view a dry-run.
@bump *ARGS:
    pdm run bumpver update --patch {{ ARGS }}
    pdm sync

# Use BumpVer to increase the minor version number. Use just bump -d to view a dry-run.
@bump-minor *ARGS:
    pdm run bumpver update --minor {{ ARGS }}
    pdm sync

# Use BumpVer to increase the major version number. Use just bump -d to view a dry-run.
@bump-major *ARGS:
    pdm run bumpver update --major {{ ARGS }}
    pdm sync

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

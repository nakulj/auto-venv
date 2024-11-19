# Based on https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e


# Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
    # Prevent running during command substitution
    status --is-command-substitution; and return

    # Check if we are inside a git repository
    if command git rev-parse --show-toplevel &>/dev/null
        set dir (realpath (command git rev-parse --show-toplevel))
    else
        set dir (pwd)
    end

    # Find a virtual environment in the directory
    set -l VENV_DIR_NAMES env .env venv .venv
    set -l venv_dir ""
    for name in $VENV_DIR_NAMES
        if test -e "$dir/$name/bin/activate.fish"
            set venv_dir "$dir/$name"
            break
        end
    end

    # Activate venv if it was found and not activated before
    if test -n "$venv_dir" -a "$VIRTUAL_ENV" != "$venv_dir" -a -e "$venv_dir/bin/activate.fish"
        command source "$venv_dir/bin/activate.fish"
        echo "Activated virtualenv: $venv_dir ($(which python))"
    # Deactivate venv if it is activated but we're no longer in a directory with a venv
    else if test -n "$VIRTUAL_ENV" -a -z "$venv_dir"
        deactivate
        echo "Deactivated virtualenv"
    end
end

# Initial run
__auto_source_venv

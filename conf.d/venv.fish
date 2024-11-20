# Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.

# Global flag to track if we're in the middle of handling venv
set -g __VENV_HANDLING 0

function __safe_activate_venv
    # Save current state
    set -l old_path $PATH
    set -l old_pythonhome $PYTHONHOME

    # Read the activate.fish content and extract key parts
    set -l activate_script (cat $argv[1])
    
    # Set up the environment without sourcing activate.fish
    set -gx VIRTUAL_ENV (dirname (dirname $argv[1]))
    set -gx _OLD_VIRTUAL_PATH $PATH
    set -gx PATH "$VIRTUAL_ENV/bin" $PATH

    # Handle PYTHONHOME
    if set -q PYTHONHOME
        set -gx _OLD_VIRTUAL_PYTHONHOME $PYTHONHOME
        set -e PYTHONHOME
    end
    
    # Set prompt
    set -gx VIRTUAL_ENV_PROMPT (basename "$VIRTUAL_ENV")
end

function __handle_virtualenv_inheritance --on-event fish_prompt
    # Only run in new shells that have inherited VIRTUAL_ENV
    if test -n "$VIRTUAL_ENV" -a -z "$__VENV_INITIALIZED" -a "$__VENV_HANDLING" -eq 0
        # Mark this shell as initialized and prevent recursive handling
        set -g __VENV_INITIALIZED 1
        set -g __VENV_HANDLING 1
        
        # Clear inherited environment
        set -l old_path $PATH
        set -e VIRTUAL_ENV
        set -e _OLD_VIRTUAL_PATH
        set -e _OLD_VIRTUAL_PYTHONHOME
        set -e PYTHONHOME
        set -e VIRTUAL_ENV_PROMPT
        set -gx PATH $old_path

        # Let auto_source_venv handle activation if needed
        __auto_source_venv

        set -g __VENV_HANDLING 0
    end
end

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
    # Prevent running during command substitution or if we're already handling venv
    status --is-command-substitution; and return
    test "$__VENV_HANDLING" -eq 1; and return

    set -g __VENV_HANDLING 1

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
        __safe_activate_venv "$venv_dir/bin/activate.fish"
        echo "Activated virtualenv: $venv_dir ($(which python))"
    # Deactivate venv if it is activated but we're no longer in a directory with a venv
    else if test -n "$VIRTUAL_ENV" -a -z "$venv_dir"
        # Save PATH before deactivation
        set -l old_path $PATH
        
        # Try to deactivate safely
        if functions -q deactivate
            functions -q deactivate; and deactivate
            # Restore PATH if it was unset
            if test -z "$PATH"
                set -gx PATH $old_path
            end
        else
            # Manual cleanup if deactivate isn't available
            set -e VIRTUAL_ENV
            set -e _OLD_VIRTUAL_PATH
            set -e _OLD_VIRTUAL_PYTHONHOME
            set -e PYTHONHOME
            set -e VIRTUAL_ENV_PROMPT
            set -gx PATH $old_path
        end
        echo "Deactivated virtualenv"
    end

    set -g __VENV_HANDLING 0
end

# Only run initial check if we're not already handling venv
if test "$__VENV_HANDLING" -eq 0
    __auto_source_venv
end

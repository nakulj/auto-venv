# Based on https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e


# Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.


function __venv_base
  git rev-parse --show-toplevel 2>/dev/null; or pwd
end

function __handle_venv_activation --argument dir 
  # Find a virtual environment in the directory
  set VENV_DIR_NAMES env .env venv .venv
  for venv_dir in $dir/$VENV_DIR_NAMES
    if test -e "$venv_dir/bin/activate.fish"
      break
    end
  end

  # Activate venv if it was found and not activated before
  if test "$VIRTUAL_ENV" != "$venv_dir" -a -e "$venv_dir/bin/activate.fish"
    source $venv_dir/bin/activate.fish
  # Deactivate venv if it is activated but the directory doesn't exist
  else if not test -z "$VIRTUAL_ENV" -o -e "$venv_dir"
    deactivate
  end
end

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
  status --is-command-substitution; and return
  __handle_venv_activation (__venv_base)
end

__auto_source_venv

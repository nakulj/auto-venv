# Based on https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e


# Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
  status --is-command-substitution; and return

  # Check if we are inside a git directory
  if git rev-parse --show-toplevel &>/dev/null
    set gitdir (realpath (git rev-parse --show-toplevel))
  else
    set gitdir ""
  end

  # find a virtual environment in the git directory

  set VENV_DIR_NAMES env .env venv .venv
  for venv_dir in $gitdir/$VENV_DIR_NAMES
    if test -e "$venv_dir/bin/activate.fish"
      break
    end
  end


  # If venv is not activated or a different venv is activated and venv exist.
  if test "$VIRTUAL_ENV" != "$venv_dir" -a -e "$venv_dir/bin/activate.fish"
    source $venv_dir/bin/activate.fish
  # If venv activated but the current (git) dir has no venv.
  else if not test -z "$VIRTUAL_ENV" -o -e "$venv_dir"
    deactivate
  end
end

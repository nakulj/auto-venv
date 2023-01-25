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

  # If venv is not activated or a different venv is activated and venv exist.
  if test "$VIRTUAL_ENV" != "$gitdir/.venv" -a -e "$gitdir/.venv/bin/activate.fish"
    source $gitdir/.venv/bin/activate.fish
  # If venv activated but the current (git) dir has no venv.
  else if not test -z "$VIRTUAL_ENV" -o -e "$gitdir/.venv"
    deactivate
  end
end

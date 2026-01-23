# Based on https://gist.github.com/tommyip/cf9099fa6053e30247e5d0318de2fb9e


# Based on https://gist.github.com/bastibe/c0950e463ffdfdfada7adf149ae77c6f
# Changes:
# * Instead of overriding cd, we detect directory change. This allows the script to work
#   for other means of cd, such as z.
# * Update syntax to work with new versions of fish.

source ./venv_helpers.fish

function __auto_source_venv --on-variable PWD --description "Activate/Deactivate virtualenv on directory change"
  status --is-command-substitution; and return
  __handle_venv_activation (__venv_base)
end

__auto_source_venv

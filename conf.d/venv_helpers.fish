# where to look for virtual environments
function __venv_base
  git rev-parse --show-toplevel 2>/dev/null; or pwd
end

# find the virtualenv, whatever it is called
function __venv --argument-names dir
  set VENV_DIR_NAMES env .env venv .venv
  for venv_dir in $dir/$VENV_DIR_NAMES
    if test -e "$venv_dir/bin/activate.fish"
      echo "$venv_dir"
      return
    end
  end
  return 1
end

function __handle_venv_activation --argument-names dir
    
    #echo "looking in venv dir:" (__venv $dir)
    set -l venv_dir (__venv $dir); or begin
      #echo "no virtual env found"
      # no virtual env found, deactivate any existing virtual env 
      set -q VIRTUAL_ENV; and deactivate
      return
    end
    #echo "found a virtual env: $venv_dir"
    #echo "current virtual env: $VIRTUAL_ENV"

    if test "$VIRTUAL_ENV" != "$venv_dir"
      #echo "not equal"
      source "$venv_dir/bin/activate.fish"
    end
end

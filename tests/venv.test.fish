source (dirname (status -f))/../conf.d/venv_helpers.fish

# TODO: figure out if these tests can be less stateful

set tmp (mktemp -d)

# __venv_base tests

@test "returns PWD outside git repo" (
  cd $tmp
  __venv_base
) -ef $tmp


@test "returns git root at git root" (
  git init $tmp/git_repo > /dev/null
  cd git_repo
  __venv_base
) -ef "$tmp/git_repo"


@test "returns git root inside git repo" (
  mkdir $tmp/git_repo/dir_in_repo
  cd $tmp/git_repo/dir_in_repo
  __venv_base
) -ef "$tmp/git_repo"

# __venv tests

@test "no output if no virtual env found" (__venv $tmp) -z

@test "returns venv directory" (
  mkdir -p $tmp/venv/bin
  touch $tmp/venv/bin/activate.fish
  __venv $tmp
) -ef "$tmp/venv"

# __handle_venv_activation tests

function deactivate
  echo "deactivated"
end

function source
  if string match -q '*activate.fish' $argv[1]
    echo "sourced $argv"
    return
  end
  builtin source $argv
end


@test "new environment is activated" (
  mkdir -p $tmp/venv/bin
  __handle_venv_activation $tmp
) = "sourced $tmp/venv/bin/activate.fish"

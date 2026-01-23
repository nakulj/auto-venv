source (dirname (status -f))/../conf.d/venv_helpers.fish

# TODO: figure out if these tests can be less stateful

set tmp (mktemp -d)

# __venv_base tests

@test "returns PWD outside git repo" (
  cd $tmp
  __venv_base
) -ef $tmp

git init $tmp/git_repo > /dev/null
cd git_repo

@test "returns git root at git root" (__venv_base) -ef "$tmp/git_repo"

mkdir $tmp/git_repo/dir_in_repo
cd $tmp/git_repo/dir_in_repo

@test "returns git root inside git repo" (__venv_base) -ef "$tmp/git_repo"

# __venv tests

cd $tmp

@test "no output if no virtual env found" (__venv $tmp) -z

mkdir -p venv/bin
touch venv/bin/activate.fish


@test "returns venv directory" (__venv $tmp) -ef "$tmp/venv"

# __handle_venv_activation tests

# Mocks 
function source
  echo "sourced $argv"
end

function deactivate
  echo "deactivated"
end

@test "new environment is activated" (__handle_venv_activation $tmp) = "sourced $tmp/venv/bin/activate.fish"


source (dirname (status -f))/../conf.d/venv.fish

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
  rm -rf $tmp/git_repo
) -ef "$tmp/git_repo"


@test "returns git root inside git repo" (
  git init $tmp/git_repo > /dev/null
  mkdir $tmp/git_repo/dir_in_repo
  cd $tmp/git_repo/dir_in_repo
  __venv_base
  rm -rf $tmp/git_repo
) -ef "$tmp/git_repo"

# __venv tests

@test "no output if no virtual env found" (
  mkdir $tmp/no_venv_dir
  __venv $tmp/no_venv_dir
  rm -rf $tmp/no_venv_dir
) -z

@test "returns venv directory" (
  mkdir -p $tmp/venv_dir/venv/bin
  touch $tmp/venv_dir/venv/bin/activate.fish
  __venv $tmp/venv_dir
  rm -rf $tmp/venv_dir
) -ef "$tmp/venv_dir/venv"

# __handle_venv_activation tests

function deactivate
  echo "deactivated"
end

function source
  if string match -q '*activate.fish' $argv[1]
    set -gx VIRTUAL_ENV (string replace -r '/bin/activate\.fish$' '' $argv)
    echo "sourced $argv"
    return
  end
  builtin source $argv
end


@test "new environment is activated" (
  mkdir -p $tmp/venv_dir/venv/bin
  touch $tmp/venv_dir/venv/bin/activate.fish
  __handle_venv_activation $tmp/venv_dir
  rm -rf $tmp/venv_dir
  set -e VIRTUAL_ENV
) = "sourced $tmp/venv_dir/venv/bin/activate.fish"


@test "same environment is not re-activated" (
  mkdir -p $tmp/venv_dir/venv/bin
  touch $tmp/venv_dir/venv/bin/activate.fish
  __handle_venv_activation $tmp/venv_dir
  rm -rf $tmp/venv_dir
  set -e VIRTUAL_ENV
) = "sourced $tmp/venv_dir/venv/bin/activate.fish"

@test "environment is changed correctly" (
  mkdir -p $tmp/a/venv/bin
  touch $tmp/a/venv/bin/activate.fish
  mkdir -p $tmp/b/venv/bin
  touch $tmp/b/venv/bin/activate.fish
  begin
    __handle_venv_activation $tmp/a
    __handle_venv_activation $tmp/b
  end | string collect
  rm -rf $tmp/a
  rm -rf $tmp/b
  set -e VIRTUAL_ENV
)  = "sourced $tmp/a/venv/bin/activate.fish
sourced $tmp/b/venv/bin/activate.fish"

@test "environment is deactivated" (
  mkdir -p $tmp/venv_dir/venv/bin
  touch $tmp/venv_dir/venv/bin/activate.fish
  mkdir $tmp/no_venv_dir
  begin
    __handle_venv_activation $tmp/venv_dir
    __handle_venv_activation $tmp/no_venv_dir
  end | string collect
  rm -rf $tmp/venv_dir
  rm -rf $tmp/no_venv_dir
  set -e VIRTUAL_ENV
) = "sourced $tmp/venv_dir/venv/bin/activate.fish
deactivated"

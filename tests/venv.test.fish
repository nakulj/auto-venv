source (dirname (status -f))/../conf.d/venv.fish

set tmp (mktemp -d)

# __venv_base tests

cd $tmp
@test "returns PWD outside git repo" (__venv_base) -ef $tmp

git init git_repo > /dev/null
cd git_repo

@test "returns git root at git root" (__venv_base) -ef "$tmp/git_repo"

mkdir git_repo_dir
cd git_repo_dir

@test "returns git root inside git repo" (__venv_base) -ef "$tmp/git_repo"



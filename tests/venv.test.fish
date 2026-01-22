# --- MOCKS ---

function git
    # Check for the specific flag the script uses
    if contains -- --show-toplevel $argv
        if set -q IN_GIT_REPO
            echo "$IN_GIT_REPO"
            return 0
        end
        return 1
    end
    # Safety: Fail loudly if the script tries to run a git command we didn't expect
    echo "TEST FAILURE: Underspecified mock. Unexpected git command: git $argv" >&2
    return 1
end

function source
    echo "SOURCED: $argv"
end

function deactivate
    echo DEACTIVATED
end

# Load your plugin
source (dirname (status -f))/../conf.d/venv.fish

# --- TESTS ---

@test "Git: Uses git root when inside a repository" (
    # Setup: We are in a repo rooted at /tmp/git-root
    set -g IN_GIT_REPO "/tmp/git-root"
    
    __get_venv_search_dir
) = /tmp/git-root

@test "Git: Falls back to PWD when NOT in a repository" (
    # Setup: We are NOT in a repo (ensure var is unset)
    set -e IN_GIT_REPO
    
    # Run helper
    __get_venv_search_dir
) = (pwd)

@test "Activation: Sources .venv/bin/activate.fish if found" (
    set -l mock_dir (mktemp -d)
    mkdir -p $mock_dir/.venv/bin
    touch $mock_dir/.venv/bin/activate.fish

    __handle_venv_activation $mock_dir
) = "SOURCED: $mock_dir/.venv/bin/activate.fish"

@test "Deactivation: Runs deactivate if leaving a venv" (
    set -g VIRTUAL_ENV "/tmp/old-venv"
    set -l empty_dir (mktemp -d)

    __handle_venv_activation $empty_dir
) = DEACTIVATED

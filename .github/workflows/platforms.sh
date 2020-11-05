set_dbx_token() {
  cp ./bricksflow/.env.dist ./bricksflow/.env
  sed -i.bak 's/DBX_TOKEN=/DBX_TOKEN=abcdefgh123456789/g' ./bricksflow/.env # set DBX_TOKEN to non-empty value
}

run_tests() {
  local REPOSITORY_SHORTNAME="$1"
  local SHELLNAME="$2"
  local RC_FILE_NAME="$3"

  build_benvy $REPOSITORY_SHORTNAME
  test_init $SHELLNAME
  test_init_2
  test_pyfony_env_creation
  test_rcfile_modifications $RC_FILE_NAME
}

build_benvy() {
  local REPOSITORY_SHORTNAME="$1"
  CONDA_BASE_DIR=$(conda info --base | sed 's/\\/\//g')

  if [ -d "$CONDA_BASE_DIR/Scripts" ]; then
    CONDA_BIN_DIR="$CONDA_BASE_DIR/Scripts" # Windows
  else
    CONDA_BIN_DIR="$CONDA_BASE_DIR/bin" # Linux/Mac
  fi

  $CONDA_BIN_DIR/pip install .
  cd $REPOSITORY_SHORTNAME
}

test_init() {
  local SHELLNAME="$1"

  echo "******* 1. invocation of benvy-init *******"

  $CONDA_BIN_DIR/benvy-init -y --verbose
  eval "$(conda shell.$SHELLNAME hook)"
  conda activate "$PWD/.venv"
  ./run_tests.sh
  ./pylint.sh
}

test_init_2() {
  echo "******* 2. invocation of benvy-init *******"

  ~/.poetry/bin/poetry add exponea-python-sdk="0.1.*"
  pip uninstall -y exponea-python-sdk
  $CONDA_BIN_DIR/benvy-init -y --verbose
  ./run_tests.sh
}

test_pyfony_env_creation() {
  echo "******* testing pyfony_env.sh creation *******"

  if [[ ! -f "$HOME/pyfony_env.sh" ]]; then
      echo "pyfony_env.sh was not created"
      exit 1
  fi
}

test_rcfile_modifications() {
  echo "******* testing .*rc file modification *******"

  local RC_FILE_NAME="$1"

  if ! grep -q "pyfony_env.sh" "$HOME/$RC_FILE_NAME"; then
      echo "pyfony_env.sh was not added to $RC_FILE_NAME"
      exit 1
  fi
}

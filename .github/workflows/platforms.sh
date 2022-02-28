set_dbx_token() {
  cp ./daipe-project/.env.dist ./daipe-project/.env
  sed -i.bak 's/DBX_TOKEN=/DBX_TOKEN=abcdefgh123456789/g' ./daipe-project/.env # set DBX_TOKEN to non-empty value
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
  conda run -n base pip install .
  cd $REPOSITORY_SHORTNAME
}

test_init() {
  local SHELLNAME="$1"

  echo "******* 1. invocation of benvy-init *******"

  conda run -n base benvy-init -y --verbose
  eval "$(conda shell.$SHELLNAME hook)"
  conda activate "$PWD/.venv"
}

test_init_2() {
  echo "******* 2. invocation of benvy-init *******"

  ~/.poetry/bin/poetry add exponea-python-sdk="0.1.*"
  pip uninstall -y exponea-python-sdk
  conda run -n base benvy-init -y --verbose
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

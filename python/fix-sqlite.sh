# Your sqlite python extension does not allow you to alter the sql master table
# even thought the `writable_schema` pragma is set to 1? This is because the
# default sqlite build on OSX Monterey sets the defensive connection flag by
# default. This can only be changed by compiling python against a
# non-proprietary sqlite build.

PYTHON_VERSION="${1:-3.10.4}"
PYENV_ROOT="${PYENV_ROOT:-~/.pyenv}"

# install a non-proprietary sqlite build
echo "Install sqlite3"
brew install sqlite3 

# now compile python against that sqlite
echo "Install python"
export LDFLAGS="-L$(brew --prefix sqlite3)/lib"
export CFLAGS="-I$(brew --prefix sqlite3)/include"
pyenv install "$PYTHON_VERSION"

# verify that the python sqlite extension is built against the homebrew sqlite
echo "Linked libraries of Python SQLite extension. They should link to $(brew --prefix sqlite):"
otool -L ~/.pyenv/versions/$PYTHON_VERSION/lib/python*/lib-dynload/_sqlite3.cpython-*-darwin.so

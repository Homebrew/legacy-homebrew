require "formula"

class FastDownward < Formula
  homepage "http://fast-downward.org"
  url "http://hg.fast-downward.org/archive/tip.tar.gz"
  sha1 "3d5af8fa0866a6e65a17c8524e063f8ac8e6d1ae"
  version "1.0.0"

  depends_on "gcc" => :build
  depends_on "cmake" => :build
  depends_on "python"
  depends_on "flex" => :build
  depends_on "bison" => :build
  depends_on "gnu-time"
  depends_on "gawk"

  def install
  	#gcc = "/usr/local/bin/g++-4.9"
    gcc = "/usr/local/bin/g++-#{Formula['gcc'].version_suffix}"

    # compile
    system "cd src/preprocess && make CXX=#{gcc} CC=#{gcc}"
    system "cd src/search && make CXX=#{gcc} CC=#{gcc}"

	script = '#! /bin/bash

set -e

BASEDIR="$(dirname $(readlink "$0"))"

function die {
    echo "$@" 1>&2
    exit 1
}

function usage {
    die "usage: $(basename "$0") [DOMAIN_FILE] PROBLEM_FILE SEARCH_OPTION ..."
}

# Paths to planner components
TRANSLATE="$BASEDIR/translate/translate.py"
PREPROCESS="$BASEDIR/preprocess/preprocess"
SEARCH="$BASEDIR/search/downward"

# Need to explicitly ask for GNU time (from MacPorts) on Mac OS X.
if [[ "$(uname)" == "Darwin" ]]; then
    TIME="gtime"
    if ! which $TIME >/dev/null; then
        die "$TIME must be installed on Mac OSX (from MacPorts, perhaps) for this to work"
    fi
else
    TIME="command time"
fi

TIME="$TIME --output=elapsed.time --format=%S\n%U\n"

if [[ "$#" -lt 2 ]]; then
    usage
fi

echo "1. Running translator"
if [[ -e "$2" ]]; then
    echo "Second argument is a file name: use two translator arguments."
    $TIME "$TRANSLATE" "$1" "$2"
    shift 2
else
    echo "Second argument is not a file name: auto-detect domain file."
    $TIME "$TRANSLATE" "$1"
    shift
fi
echo

echo "2. Running preprocessor"
$TIME --append "$PREPROCESS" < output.sas
echo

echo "3. Running search"
"$SEARCH" < output "$@"
echo
'
    # install
    system "mkdir #{prefix}/preprocess && cp -f src/preprocess/preprocess #{prefix}/preprocess/"
    system "mkdir #{prefix}/search && cp -f src/search/downward-release #{prefix}/search/"
    system "cp -f src/search/downward #{prefix}/search/"
    system "cp -f src/search/unitcost #{prefix}/search/"
    system "cp -rf src/translate #{prefix}/translate"
    system "cp -f src/cleanup #{prefix}/cleanup"
	File.open("#{prefix}/plan", 'w') { |f| f.write(script) }
	system "chmod +x #{prefix}/plan"

    system "ln -sf #{prefix}/preprocess/preprocess /usr/local/bin/fast-downward-preprocess"
    system "ln -sf #{prefix}/search/downward-release /usr/local/bin/fast-downward-search"
    system "ln -sf #{prefix}/plan /usr/local/bin/fast-downward"
    system "ln -sf #{prefix}/cleanup /usr/local/bin/fast-downward-cleanup"
  end

  def uninstall
    system "rm -f /usr/local/bin/fast-downward-preprocess"
    system "rm -f /usr/local/bin/fast-downward-search"
    system "rm -f /usr/local/bin/fast-downward"
    system "rm -f /usr/lcoal/bin/fast-downward-cleanup"
  end

  test do
    system "/usr/bin/file /usr/local/bin/fast-downward"
  end
end

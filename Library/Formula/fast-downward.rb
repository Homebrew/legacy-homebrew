require "formula"

class FastDownward < Formula
  homepage "http://fast-downward.org"
  url "http://herry13.github.io/fd/fast-downward-1.0.0.tar.gz"
  sha1 "df0e0565d2774048cf51924182cf69c402c13f8a"

  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "bison" => :build

  fails_with :clang do
    cause "Clang does no recognize 'tr1' library e.g. '#include <tr1/unordered_set>'"
  end

  fails_with :llvm do
    cause "it does no recognize 'tr1' library e.g. '#include <tr1/unordered_set>'"
  end

  def install
    # compile
    system 'make'

    # install
    bin.mkpath
    (prefix/'preprocess').mkpath
    (prefix/'search').mkpath
    system 'make', "PREFIX=#{prefix}", 'install'
  end

  test do
    system 'fast-downward', 'test/airport-01-domain.pddl', 'test/airport-01-problem.pddl', '--search "lazy_greedy(ff())"'
  end
end

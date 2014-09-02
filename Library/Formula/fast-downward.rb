require "formula"

class FastDownward < Formula
  homepage "http://fast-downward.org"
  url "http://herry13.github.io/fd/fast-downward-1.0.0.tar.gz"
  sha1 "bb319e768dd9ced9735164caf53ac0c2ec182bdc"

  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "bison" => :build

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

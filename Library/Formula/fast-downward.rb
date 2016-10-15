require "formula"

class FastDownward < Formula
  homepage "http://fast-downward.org"
  url "http://herry13.github.io/fd/fast-downward-1.0.0.tar.gz"
  sha1 "88ef8278760323cd6f8e78ff6fc323c74caa8999"

  depends_on "cmake" => :build
  depends_on "flex" => :build
  depends_on "bison" => :build

  def install
    system "make"

    bin.mkpath
    (prefix/"share").mkpath
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "fast-downward", "test/airport-01-domain.pddl", "test/airport-01-problem.pddl", "--search 'lazy_greedy(ff())'"
  end
end

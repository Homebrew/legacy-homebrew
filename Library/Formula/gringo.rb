class Gringo < Formula
  desc "Grounder to translate user-provided logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/gringo/4.5.2/gringo-4.5.2-source.tar.gz"
  sha256 "36d86321c54499cabf498dac0923b39e43c7a248919224a11c2d15e4ecec9d65"

  bottle do
    cellar :any
    sha256 "43fcc7b73c6d854535dda78755a76790ae9410b95aa00d1ed155c8b6610350f2" => :yosemite
    sha256 "3aa1597570e03f0dbb4741b6cb4a5834f6799d0e64514baa1cf7de5b5e1f7b07" => :mavericks
    sha256 "ec8e660616f582857b9f2943fae273460db3de9d2524eebedc922118fd4fec2e" => :mountain_lion
  end

  depends_on "re2c" => :build
  depends_on "scons" => :build
  depends_on "bison" => :build

  needs :cxx11

  def install
    # Allow pre-10.9 clangs to build in C++11 mode
    ENV.libcxx

    inreplace "SConstruct",
              "env['CXX']            = 'g++'",
              "env['CXX']            = '#{ENV.cxx}'"

    scons "--build-dir=release", "gringo", "clingo", "reify"
    bin.install "build/release/gringo", "build/release/clingo", "build/release/reify"
  end

  test do
    assert_match /#{version}/, shell_output("#{bin}/gringo --version")
  end
end

class Gringo < Formula
  desc "Grounder to translate user-provided logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/gringo/4.5.3/gringo-4.5.3-source.tar.gz"
  mirror "https://mirrors.kernel.org/debian/pool/main/g/gringo/gringo_4.5.3.orig.tar.gz"
  sha256 "feb53913e697052e45c0d3a75ab9d2bb097abf6751caf452df3afa4376298825"

  bottle do
    cellar :any_skip_relocation
    sha256 "7413d94e07e8eec626478ce76b447ddf831d1f2df4ae4b91d70dc82c3b433025" => :el_capitan
    sha256 "c71569ae85dac1aea9e0570ef43401063f66dc9a855bc9a4fa804bf381bc5ad3" => :yosemite
    sha256 "68d7c04b3a00fc02b87f4db25d39fbfe53b340f28fae1dfc38566d37aa7b5d89" => :mavericks
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

class Gringo < Formula
  desc "Grounder to translate user-provided logic programs"
  homepage "http://potassco.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/potassco/gringo/4.5.2/gringo-4.5.2-source.tar.gz"
  sha256 "36d86321c54499cabf498dac0923b39e43c7a248919224a11c2d15e4ecec9d65"

  bottle do
    cellar :any_skip_relocation
    sha256 "36afcdf678bf6acd9f3e74346a020d8e681009e96fedbc743850defe39c28012" => :el_capitan
    sha256 "af11fe60cfa45810026ba55e5c33cd413610a2473f30dd587e84cab0f8502766" => :yosemite
    sha256 "010d4f22a7c47424429ef1b7d27d29362d5f1d583588b4232fd761fe8dd16ad3" => :mavericks
    sha256 "2510f63c6adba3367c596ebd54ba796155d9e1d4a1a37dfc642f444cb51ab7da" => :mountain_lion
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

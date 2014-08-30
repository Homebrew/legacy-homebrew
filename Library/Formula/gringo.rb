require 'formula'

class Gringo < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/gringo/4.4.0/gringo-4.4.0-source.tar.gz'
  sha1 'c39a1c3cfe64b62e39e6abcc8f813e2d1d17251e'

  bottle do
    cellar :any
    sha1 "aec4b6d3102b348eea454358687dae450314d07e" => :mavericks
    sha1 "65977cfd320b3092dc64ea94a43d7da678777f86" => :mountain_lion
    sha1 "1aae13a3eff4fa7fab14dc3e4749ad7afce3dcf1" => :lion
  end

  depends_on 're2c'  => :build
  depends_on 'scons' => :build
  depends_on 'bison' => :build

  needs :cxx11

  def install
    # Allow pre-10.9 clangs to build in C++11 mode
    ENV.libcxx
    inreplace "SConstruct",
              "env['CXX']            = 'g++'",
              "env['CXX']            = '#{ENV['CXX']}'"
    scons "--build-dir=release", "gringo", "clingo"
    bin.install "build/release/gringo", "build/release/clingo"
  end
end

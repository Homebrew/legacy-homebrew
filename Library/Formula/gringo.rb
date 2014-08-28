require 'formula'

class Gringo < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/gringo/4.4.0/gringo-4.4.0-source.tar.gz'
  sha1 'c39a1c3cfe64b62e39e6abcc8f813e2d1d17251e'

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

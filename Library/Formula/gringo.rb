require 'formula'

class Gringo < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/gringo/4.4.0/gringo-4.4.0-source.tar.gz'
  sha1 'c39a1c3cfe64b62e39e6abcc8f813e2d1d17251e'
  revision 1

  bottle do
    cellar :any
    sha1 "53aa3f2faea4ed8018e182ad116b580a258f5f0b" => :yosemite
    sha1 "169c5ce2e52e5e60b8dc9cf1a7bea91d2068ce7d" => :mavericks
    sha1 "dbf6db34bc0ea8858ce4a3d3a3f65d874d96133b" => :mountain_lion
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
              "env['CXX']            = '#{ENV.cxx}'"
    scons "--build-dir=release", "gringo", "clingo"
    bin.install "build/release/gringo", "build/release/clingo"
  end
end

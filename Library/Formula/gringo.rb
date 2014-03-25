require 'formula'

class Gringo < Formula
  homepage 'http://potassco.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/potassco/gringo/4.3.0/gringo-4.3.0-source.tar.gz'
  sha1 'dccb55c2c690ebe1f6599a43b6072bfb50eb5e83'

  bottle do
    cellar :any
    sha1 "1dc4996fd4469e987a5aab9c205cf157c3460c01" => :mavericks
  end

  depends_on 're2c'  => :build
  depends_on 'scons' => :build
  depends_on 'bison' => :build
  depends_on :macos => :mavericks

  def install
    scons "--build-dir=release", "gringo", "clingo"
    bin.install "build/release/gringo", "build/release/clingo"
  end
end

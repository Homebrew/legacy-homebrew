require 'formula'

class Libxc < Formula
  homepage 'http://www.tddft.org/programs/octopus/wiki/index.php/Libxc'
  url 'http://www.tddft.org/programs/octopus/down.php?file=libxc/libxc-2.2.0.tar.gz'
  sha1 '77c3ffe2c664339f3eafbf7642ddeba482b88074'

  bottle do
    cellar :any
    revision 1
    sha1 "965d55368d68485a4fc0c2517501b99b41dc772a" => :yosemite
    sha1 "253d9649431b8dfa61f188877b98f4d4cad83f00" => :mavericks
    sha1 "021513e19e1b86cd9ef49641bbb102d9f63b0a08" => :mountain_lion
  end

  depends_on :fortran

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--enable-shared",
                          "FCCPP=#{ENV.fc} -E -x c",
                          "CC=#{ENV.cc}",
                          "CFLAGS=-pipe"
    system "make"
    system "make install"
  end
end

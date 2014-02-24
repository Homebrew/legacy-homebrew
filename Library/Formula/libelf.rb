require 'formula'

class Libelf < Formula
  homepage 'http://www.mr511.de/software/'
  url 'http://www.mr511.de/software/libelf-0.8.13.tar.gz'
  sha1 'c1d6ac5f182d19dd685c4dfd74eedbfe3992425d'

  bottle do
    cellar :any
    sha1 "c7d1a8c7ee850b45fc94f8ea001cc111f7c95a47" => :mavericks
    sha1 "a6956bd408df4de415185c4050a0e36f868b09e3" => :mountain_lion
    sha1 "6fed390c4707aa777cad0a45c6a1ccc5b47c59b2" => :lion
  end

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-compat"
    # Use separate steps; there is a race in the Makefile.
    system "make"
    system "make install"
  end
end

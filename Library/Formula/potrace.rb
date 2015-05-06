require 'formula'

class Potrace < Formula
  homepage 'http://potrace.sourceforge.net'
  url 'http://potrace.sourceforge.net/download/1.12/potrace-1.12.tar.gz'
  sha1 'e66bd7d6ff74fe45a07d4046f6303dec5d23847f'

  bottle do
    cellar :any
    sha256 "c9141e2c9d92ba0c3a756de14847460d912a4fe4fac3a43031e43fda61337fbb" => :yosemite
    sha256 "9a3f518d257b71a24f392fe3fa2602c6d0c83930cdb2595088c4478bb07d27e9" => :mavericks
    sha256 "646426083e81564f2345d173b493f99e356c29b23947e1f1ccfec932bfa14d97" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make install"
  end
end

require 'formula'

class Tcl < Formula
  url 'http://downloads.sourceforge.net/project/tcl/Tcl/8.5.10/tcl8.5.10-src.tar.gz'
  homepage 'http://www.tcl.tk/'
  md5 'a08eaf8467c0631937067c1948dd326b'
  version '8.5.10'

  def install
    system "./unix/configure", "--prefix=#{prefix}", "--mandir=#{man}", "--disable-corefoundation",
    		"--enable-framework", "--enable-aqua"
    system "make install"
  end
end
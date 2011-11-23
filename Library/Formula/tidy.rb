require 'formula'

class Tidy < Formula
  head 'cvs://:pserver:anonymous@tidy.cvs.sourceforge.net:/cvsroot/tidy:tidy'
  homepage 'http://tidy.sourceforge.net'
  version '2009'  # date of last commit

  def install
    system "/bin/sh build/gnuauto/setup.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

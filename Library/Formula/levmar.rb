require 'formula'

class Levmar < Formula
  homepage 'http://www.ics.forth.gr/~lourakis/levmar/'
  url 'http://www.ics.forth.gr/~lourakis/levmar/levmar-2.6.tgz'
  sha1 '118bd20b55ab828d875f1b752cb5e1238258950b'

  def install
    inreplace 'Makefile', '-lf2c',''
    system "make"
    include.install "levmar.h"
    lib.install "liblevmar.a"
    prefix.install "lmdemo"
  end

  def test
    system "#{prefix}/lmdemo"
  end
end

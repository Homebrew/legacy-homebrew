require 'formula'

class Unrtf < Formula
  homepage 'http://www.gnu.org/software/unrtf/'
  url 'http://ftpmirror.gnu.org/unrtf/unrtf-0.21.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/unrtf/unrtf-0.21.5.tar.gz'
  sha1 '73d22805eb7a83edf5c3c27fe036e3c33248902d'

  # Per MacPorts, add a return value to fix compiling with clang, and fix
  # a bad memory access.
  patch :p0 do
    url "https://trac.macports.org/export/94428/trunk/dports/textproc/unrtf/files/patch-src-attr.c.diff"
    sha1 "8a6a111373d6bf18750bbb5bf2d91383ac6aa584"
  end

  def install
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make install"
  end
end

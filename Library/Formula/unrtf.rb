require 'formula'

class Unrtf < Formula
  homepage 'http://www.gnu.org/software/unrtf/'
  url 'http://ftpmirror.gnu.org/unrtf/unrtf-0.21.3.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/unrtf/unrtf-0.21.3.tar.gz'
  sha1 'a5737c647008c84632297c41d5e0ad1ed806727b'

  # Per MacPorts, add a return value to fix compiling with clang, and fix
  # a bad memory access.
  def patches
    { :p0 => [
    "https://trac.macports.org/export/94428/trunk/dports/textproc/unrtf/files/patch-src-attr.c.diff"
    ]}
  end

  def install
    system "./configure", "LIBS=-liconv", "--prefix=#{prefix}"
    system "make install"
  end
end

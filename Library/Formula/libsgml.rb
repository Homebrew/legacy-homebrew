require 'formula'

class Libsgml < Formula
  url 'http://hick.org/code/skape/libsgml/libsgml-1.1.4.tar.gz'
  homepage 'http://hick.org'
  md5 'a3ba2f8c19faf1a53182d9c6fab22e58'

  def patches
    { :p0 => [
      "https://trac.macports.org/export/89276/trunk/dports/textproc/libsgml/files/patch-examples_variant.c.diff",
      "https://trac.macports.org/export/89276/trunk/dports/textproc/libsgml/files/patch-src_Variant.c.diff",
      "https://trac.macports.org/export/89276/trunk/dports/textproc/libsgml/files/patch-Makefile.in.diff",
      "https://trac.macports.org/export/89276/trunk/dports/textproc/libsgml/files/patch-configure.in.diff",
      "https://trac.macports.org/export/89276/trunk/dports/textproc/libsgml/files/patch-src_Makefile.in.diff"
      ] }
  end

  def install
    lib.mkpath
    system "autoreconf -fvi"
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make"
    system "make install"
  end
end

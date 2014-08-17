require 'formula'

class Cdparanoia < Formula
  homepage 'http://www.xiph.org/paranoia/'
  url 'http://downloads.xiph.org/releases/cdparanoia/cdparanoia-III-10.2.src.tgz'
  sha1 '1901e20d3a370ca6afa4c76a9ef30d3f03044320'

  depends_on :autoconf

  fails_with :llvm do
    build 2326
    cause '"File too small" error while linking'
  end

  patch do
    url "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/osx_interface.patch"
    sha1 "c86e573f51e6d58d5f349b22802a7a7eeece9fcd"
  end

  patch do
    url "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/patch-paranoia_paranoia.c.10.4.diff"
    sha1 "d7dc121374df3b82e82adf544df7bf1eec377bdb"
  end

  def install
    system "autoconf"
    # Libs are installed as keg-only because most software that searches for cdparanoia
    # will fail to link against it cleanly due to our patches
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--libdir=#{libexec}"
    system "make all"
    system "make install"
  end
end

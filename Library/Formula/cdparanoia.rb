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

  def patches
    [
     "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/osx_interface.patch",
     "https://trac.macports.org/export/70964/trunk/dports/audio/cdparanoia/files/patch-paranoia_paranoia.c.10.4.diff"
    ]
  end

  def install
    system "autoconf"
    # Libs are installed as keg-only because most software that searches for cdparanoia
    # will fail to link against it cleanly due to our patches
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--libdir=#{libexec}"
    system "make all"
    system "make install"
  end
end

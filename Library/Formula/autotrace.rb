require 'formula'

class Autotrace < Formula
  homepage 'http://autotrace.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/autotrace/AutoTrace/0.31.1/autotrace-0.31.1.tar.gz'
  sha1 '679e4912528030b86f23db5b99e60f8e7df883fd'
  revision 1

  depends_on 'pkg-config' => :build
  depends_on 'imagemagick' => :recommended

  # Issue 16569: Use MacPorts patch to port input-png.c to libpng 1.5.
  # Fix underquoted m4
  patch :p0 do
    url "https://trac.macports.org/export/100575/trunk/dports/graphics/autotrace/files/patch-libpng-1.5.diff"
    sha1 "b9b8bd6eca4ca41586ac1bd22cc0c5df2e1bf601"
  end

  patch :p0 do
    url "https://trac.macports.org/export/77101/trunk/dports/graphics/autotrace/files/patch-autotrace.m4.diff"
    sha1 "e9969fc23f83ad739f6c7f572b5c6d48eae910f5"
  end

  def install
    args = ["--disable-debug",
            "--disable-dependency-tracking",
            "--prefix=#{prefix}",
            "--mandir=#{man}"]

    args << "--without-magick" if build.without? 'imagemagick'

    system "./configure", *args
    system "make install"
  end
end

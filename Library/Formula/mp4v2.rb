require 'formula'

class Mp4v2 < Formula
  homepage 'http://code.google.com/p/mp4v2/'
  url 'http://mp4v2.googlecode.com/files/mp4v2-2.0.0.tar.bz2'
  sha1 '193260cfb7201e6ec250137bcca1468d4d20e2f0'

  head 'http://mp4v2.googlecode.com/svn/trunk/', :using => StrictSubversionDownloadStrategy

  if build.head?
    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "autoreconf -fiv" if build.head?
    system "./configure", "--disable-debug", "--prefix=#{prefix}"
    system "make"
    system "make install"
    system "make install-man"
  end
end


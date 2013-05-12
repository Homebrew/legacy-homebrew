require 'formula'

class Libarchive < Formula
  homepage 'http://www.libarchive.org'
  url 'http://www.libarchive.org/downloads/libarchive-3.1.2.tar.gz'
  sha1 '6a991777ecb0f890be931cec4aec856d1a195489'

  keg_only :provided_by_osx

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--without-lzma",
                          "--without-lzo2",
                          "--without-nettle",
                          "--without-xml2"
    system "make install"
  end
end

require 'formula'

class CAres < Formula
  homepage 'http://c-ares.haxx.se/'
  url 'http://c-ares.haxx.se/download/c-ares-1.8.0.tar.gz'
  sha1 'be886ef6a4238b237d865342477df751cab9757d'

  def install
    system "./configure", "--prefix=#{prefix}",
                          '--disable-dependency-tracking',
                          '--disable-debug'
    system "make install"
  end
end

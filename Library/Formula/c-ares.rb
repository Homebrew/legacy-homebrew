require 'formula'

class CAres < Formula
  homepage 'http://c-ares.haxx.se/'
  url 'http://c-ares.haxx.se/download/c-ares-1.10.0.tar.gz'
  sha1 'e44e6575d5af99cb3a38461486e1ee8b49810eb5'

  def install
    system "./configure", "--prefix=#{prefix}",
                          '--disable-dependency-tracking',
                          '--disable-debug'
    system "make install"
  end
end

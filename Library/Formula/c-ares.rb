require 'formula'

class CAres < Formula
  homepage 'http://c-ares.haxx.se/'
  url 'http://c-ares.haxx.se/download/c-ares-1.9.1.tar.gz'
  sha1 'fe41e47f300bfd587b7f552a141ad3bf85437b0f'

  def install
    system "./configure", "--prefix=#{prefix}",
                          '--disable-dependency-tracking',
                          '--disable-debug'
    system "make install"
  end
end

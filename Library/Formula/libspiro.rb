require 'formula'

class Libspiro < Formula
  homepage 'https://github.com/fontforge/libspiro'
  url 'http://downloads.sourceforge.net/project/libspiro/libspiro/20071029/libspiro_src-20071029.tar.bz2'
  sha1 'd8b407b835b35289af2914877a4c6000b4fdd382'

  head 'https://github.com/fontforge/libspiro.git'

  def install

    # Create ./configure script if building head
    if build.head?
      system "./autoreconf", "-i"
      system "./automake", "--foreign -Wall"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

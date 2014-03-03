require 'formula'

class Libspiro < Formula
  homepage 'https://github.com/fontforge/libspiro'
  url 'https://downloads.sourceforge.net/project/libspiro/libspiro/20071029/libspiro_src-20071029.tar.bz2'
  sha1 'd8b407b835b35289af2914877a4c6000b4fdd382'

  head do
    url 'https://github.com/fontforge/libspiro.git'

    depends_on :automake
    depends_on :autoconf
    depends_on :libtool
  end

  def install
    if build.head?
      system "autoreconf", "-i"
      system "automake"
    end

    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end
end

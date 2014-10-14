require 'formula'

class Libspiro < Formula
  homepage 'https://github.com/fontforge/libspiro'
  url 'https://downloads.sourceforge.net/project/libspiro/libspiro/20071029/libspiro_src-20071029.tar.bz2'
  sha1 'd8b407b835b35289af2914877a4c6000b4fdd382'

  bottle do
    cellar :any
    sha1 "4ebd6f91e64df94b0179cbf03c9501fc3b0529b4" => :mavericks
    sha1 "0688c000586452e80912483a796cfca22603f861" => :mountain_lion
    sha1 "9dd35b944eec51af1b795708fe5c4a8f53c92251" => :lion
  end

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

require 'formula'

class Blitz < Formula
  homepage 'http://blitz.sourceforge.net'
  url 'https://downloads.sourceforge.net/project/blitz/blitz/Blitz++%200.10/blitz-0.10.tar.gz'
  sha1 '7e157ec22ed2d261e896b7de4e8e8d3bf7d780e2'

  head do
    url 'http://blitz.hg.sourceforge.net:8000/hgroot/blitz/blitz', :using => :hg

    depends_on :autoconf
    depends_on :automake
    depends_on :libtool
  end

  def install
    system "autoreconf", "-fi" if build.head?

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--infodir=#{info}",
                          "--enable-shared",
                          "--disable-doxygen",
                          "--disable-dot",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

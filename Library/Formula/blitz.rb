require 'formula'

class Blitz < Formula
  homepage 'http://oonumerics.org/blitz'
  url 'http://downloads.sourceforge.net/project/blitz/blitz/Blitz%2B%2B%200.9/blitz-0.9.tar.gz'
  sha1 '055a4bcb47903e5c2446884d2df1494ac3e24034'

  head 'http://blitz.hg.sourceforge.net:8000/hgroot/blitz/blitz', :using => :hg

  if build.head?
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

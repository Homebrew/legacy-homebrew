require 'formula'

class Openslp < Formula
  homepage 'http://www.openslp.org'
  url 'https://downloads.sourceforge.net/project/openslp/2.0.0/2.0.0%20Release/openslp-2.0.0.tar.gz'
  sha1 'e4630bfb986cdffab6bb829b37e9340c9152d838'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

require 'formula'

class Clamav < Formula
  homepage 'http://www.clamav.net/'
  url 'http://downloads.sourceforge.net/clamav/clamav-0.97.4.tar.gz'
  sha1 '56f90cf8a73acba8f97beca86b42c65c3923935d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"
  end
end

require 'formula'

class Sipcalc < Formula
  url 'http://www.routemeister.net/projects/sipcalc/files/sipcalc-1.1.5.tar.gz'
  homepage 'http://www.routemeister.net/projects/sipcalc/'
  sha1 'fe2180df9e14d28407a089c9ac23e4fabfb6e2a1'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

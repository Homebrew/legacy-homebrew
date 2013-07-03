require 'formula'

class Sipcalc < Formula
  homepage 'http://www.routemeister.net/projects/sipcalc/'
  url 'http://www.routemeister.net/projects/sipcalc/files/sipcalc-1.1.6.tar.gz'
  sha1 'edc4177bf0ef7e61363ef85bbe80255448418460'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

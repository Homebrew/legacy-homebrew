require 'formula'

class Sipcalc <Formula
  url 'http://www.routemeister.net/projects/sipcalc/files/sipcalc-1.1.5.tar.gz'
  homepage 'http://www.routemeister.net/projects/sipcalc/'
  md5 '8d59e70d21d8f0568e310d342e3e2306'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

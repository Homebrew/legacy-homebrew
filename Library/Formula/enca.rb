require 'formula'

class Enca <Formula
  url 'http://dl.cihar.com/enca/enca-1.13.tar.gz'
  homepage 'http://freshmeat.net/projects/enca'
  md5 '58fcf1fea7eeab70b64a2d61e14a967d'

  depends_on 'libiconv'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

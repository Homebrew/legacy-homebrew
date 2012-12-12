require 'formula'

class Yazpp < Formula
  homepage 'http://www.indexdata.com/yazpp'
  url 'http://ftp.indexdata.dk/pub/yazpp/yazpp-1.4.0.tar.gz'
  sha1 '7781f1aa234211efa470fcd4f9900bb8a4fb3570'

  depends_on 'yaz'

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

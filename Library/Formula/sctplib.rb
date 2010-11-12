require 'formula'

class Sctplib <Formula
  url 'http://www.sctp.de/download/sctplib-1.0.9.tar.gz'
  homepage 'http://www.sctp.de/sctp.html'
  md5 '0d003c6d5d14b7c92dca86f0201c155b'

  depends_on 'glib'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

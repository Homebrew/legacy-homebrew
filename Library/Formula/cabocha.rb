require 'formula'

class Cabocha < Formula
  url 'http://cabocha.googlecode.com/files/cabocha-0.60.tar.gz'
  homepage 'http://code.google.com/p/cabocha/'
  md5 '3399873faab9b252fd57e1d48fa1285d'

  depends_on 'crf++'

  def install
    ENV["LIBS"] = "-liconv"
    system "./configure", "CXXFLAGS=#{ENV.cflags}",  "--with-charset=utf8", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

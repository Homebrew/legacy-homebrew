require 'formula'

class Tin < Formula
  homepage 'http://www.tin.org'
  url 'ftp://ftp.tin.org/pub/news/clients/tin/stable/tin-2.0.1.tar.gz'
  md5 'd05622db1712a78a2b92aa27904befc2'

  def install
    ENV.enable_warnings
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make build"
    system "make install"
  end
end

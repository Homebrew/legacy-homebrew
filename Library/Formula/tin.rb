require 'formula'

class Tin < Formula
  homepage 'http://www.tin.org'
  url 'ftp://ftp.tin.org/pub/news/clients/tin/stable/tin-2.0.1.tar.gz'
  sha1 '27d3003d90b8ee4be3a25377986f0f53955a6b5b'

  def install
    ENV.enable_warnings
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--mandir=#{man}"
    system "make build"
    system "make install"
  end
end

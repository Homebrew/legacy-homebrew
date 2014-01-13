require 'formula'

class Tin < Formula
  homepage 'http://www.tin.org'
  url 'ftp://ftp.tin.org/pub/news/clients/tin/v2.2/tin-2.2.0.tar.gz'
  sha1 '91293a529ae454f0506fc756325b4cfb9c5c235d'

  conflicts_with 'mutt',
    :because => 'both install mmdf.5 and mbox.5 man pages'

  def install
    ENV.enable_warnings
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make build"
    system "make install"
  end
end

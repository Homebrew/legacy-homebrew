require 'formula'

class Pcrexx < Formula
  homepage 'http://www.daemon.de/PCRE'
  url 'http://www.daemon.de/idisk/Apps/pcre++/pcre++-0.9.5.tar.gz'
  sha1 '7cb640555c6adf34bf366139b22f6d1a66bd1fb0'

  depends_on 'pcre'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-pcre-dir-lib=#{HOMEBREW_PREFIX}"
    system "make install"
  end
end

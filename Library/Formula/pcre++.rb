require 'formula'

class Pcrexx < Formula
  homepage 'http://www.daemon.de/PCRE'
  url 'http://www.daemon.de/idisk/Apps/pcre++/pcre++-0.9.5.tar.gz'
  md5 '1fe6ea8e23ece01fde2ce5fb4746acc2'

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

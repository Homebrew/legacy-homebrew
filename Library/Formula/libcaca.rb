require 'formula'

class Libcaca <Formula
  url 'http://caca.zoy.org/raw-attachment/wiki/libcaca/libcaca-0.9.tar.bz2'
  homepage 'http://caca.zoy.org/wiki/libcaca'
  md5 'c7d5c46206091a9203fcb214abb25e4a'

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--disable-imlib2",
                          "--disable-doc",
                          "--disable-slang"
    system "make install"
  end
end

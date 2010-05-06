require 'formula'

class Libdnet <Formula
  url 'http://libdnet.googlecode.com/files/libdnet-1.12.tgz'
  homepage 'http://code.google.com/p/libdnet/'
  md5 '9253ef6de1b5e28e9c9a62b882e44cc9'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make install"
  end
end

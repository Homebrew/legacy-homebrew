require 'formula'

class Gloox <Formula
  url 'http://camaya.net/download/gloox-1.0.tar.bz2'
  homepage 'http://camaya.net/glooxdownload'
  md5 'f8eacf1c6476e0a309b453fd04f90e31'

  def install
    system "./configure", "--without-openssl", 
                          "--with-gnutls",
                          "--with-zlib",
                          "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
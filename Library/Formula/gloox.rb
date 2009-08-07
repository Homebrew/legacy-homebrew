require 'brewkit'

class Gloox <Formula
  @url='http://camaya.net/download/gloox-1.0-beta7.tar.bz2'
  @homepage='http://camaya.net/glooxdownload'
  @md5='482bf5ed8e4c14f2788efdd9c39e9acf'

  def install
    system "./configure", "--without-openssl", 
                          "--with-gnutls",
                          "--with-zlib",
                          "--disable-debug",
                          "--prefix=#{prefix}"
    system "make install"
  end
end
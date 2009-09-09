require 'brewkit'

class Gnutls <Formula
  @url='http://ftp.gnu.org/pub/gnu/gnutls/gnutls-2.8.3.tar.bz2'
  @homepage='http://www.gnu.org/software/gnutls/gnutls.html'
  @sha1='c25fb354258777f9ee34b79b08eb87c024cada75'

  def deps
    'libgcrypt'
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

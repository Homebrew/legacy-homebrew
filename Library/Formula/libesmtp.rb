require 'formula'

class Libesmtp < Formula
  homepage 'http://www.stafford.uklinux.net/libesmtp/index.html'
  url 'http://www.stafford.uklinux.net/libesmtp/libesmtp-1.0.6.tar.bz2'
  sha1 'cf538cfc6cb15d9d99bdeb20a3b3b6b320d97df3'

  depends_on 'openssl'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "false"
  end
end

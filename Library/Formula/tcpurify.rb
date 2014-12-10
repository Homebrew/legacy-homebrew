require 'formula'

class Tcpurify < Formula
  homepage 'http://irg.cs.ohiou.edu/~eblanton/tcpurify/'
  url 'http://irg.cs.ohiou.edu/~eblanton/tcpurify/tcpurify-0.11.2.tar.gz'
  sha1 'd095de38e264afd40de6f2d7c35609a3fab4c92a'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  test do
    system "#{bin}/tcpurify", "-v"
  end
end

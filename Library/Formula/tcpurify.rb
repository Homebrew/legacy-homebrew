require 'formula'

class Tcpurify < Formula
  url 'http://irg.cs.ohiou.edu/~eblanton/tcpurify/tcpurify-0.11.2.tar.gz'
  homepage 'http://irg.cs.ohiou.edu/~eblanton/tcpurify/'
  sha1 'd095de38e264afd40de6f2d7c35609a3fab4c92a'

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "tcpurify -v" # Using -v, as without that it returns -1
  end
end

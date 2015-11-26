class Tcpurify < Formula
  desc "Packet sniffer/capture program"
  homepage "https://web.archive.org/web/20140203210616/http://irg.cs.ohiou.edu/~eblanton/tcpurify/"
  url "https://web.archive.org/web/20140203210616/http://irg.cs.ohiou.edu/~eblanton/tcpurify/tcpurify-0.11.2.tar.gz"
  sha256 "9822f88125e912c568de23b04cee7c84452eefa27a80dcaeaeb001f87cb60e99"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpurify", "-v"
  end
end

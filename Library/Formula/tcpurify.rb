class Tcpurify < Formula
  desc "Packet sniffer/capture program"
  homepage "https://web.archive.org/web/20140203210616/http://irg.cs.ohiou.edu/~eblanton/tcpurify/"
  url "https://web.archive.org/web/20140203210616/http://irg.cs.ohiou.edu/~eblanton/tcpurify/tcpurify-0.11.2.tar.gz"
  sha256 "9822f88125e912c568de23b04cee7c84452eefa27a80dcaeaeb001f87cb60e99"

  bottle do
    cellar :any_skip_relocation
    sha256 "175a4e03bb937459b72331165f08b2b144550d5c11fb7a8cb64df59685edb228" => :el_capitan
    sha256 "ed4bf4f1b14c45a444ef388ec522150956e9163980d276b6f413637a03295c49" => :yosemite
    sha256 "77e9351ead0693badafecbbe91f05f197dd0c6f5419c33d2a91f8ffdc32fa498" => :mavericks
  end

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/tcpurify", "-v"
  end
end

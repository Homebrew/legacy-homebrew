class FbClient < Formula
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-1.4.2.tar.gz"
  sha256 "a0479725a370d884a0fdbcd0380028ba9682bd48115142141e17f82930fb66f0"

  head "https://git.server-speed.net/users/flo/fb",
       :using => :git

  conflicts_with "findbugs",
    :because => "findbugs and fb-client both install a `fb` binary"

  depends_on "pkg-config" => :build

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system bin/"fb", "-h"
  end
end

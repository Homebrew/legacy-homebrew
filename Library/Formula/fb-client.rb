class FbClient < Formula
  desc "Shell-script client for http://paste.xinu.at"
  homepage "https://paste.xinu.at"
  url "https://paste.xinu.at/data/client/fb-1.4.2.tar.gz"
  sha256 "a0479725a370d884a0fdbcd0380028ba9682bd48115142141e17f82930fb66f0"

  bottle do
    cellar :any
    sha256 "7ad33c8cc5aa7ce3f7112af36f1faac14dd9a99c67d84979a5316ab83231cdcf" => :yosemite
    sha256 "d82dd808f067414d5ed32f9d6b84407122b73779fc01b60bb57a39ad38c42556" => :mavericks
    sha256 "4fbad8cedd1aec6a69a38037dbda61fdd1745693c9508a744fedd61e24621ae5" => :mountain_lion
  end

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

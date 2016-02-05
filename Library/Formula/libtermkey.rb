class Libtermkey < Formula
  desc "Library for processing keyboard entry from the terminal"
  homepage "http://www.leonerd.org.uk/code/libtermkey/"
  url "http://www.leonerd.org.uk/code/libtermkey/libtermkey-0.17.tar.gz"
  sha256 "68949364ed5eaad857b3dea10071cde74b00b9f236dfbb702169f246c3cef389"

  bottle do
    cellar :any
    revision 1
    sha256 "050eb2c5c5d60eb6c13549a58315b200c4d4a8f6f3a955e7616ef61c31c432a1" => :yosemite
    sha256 "d9de1749b5984508c0000e05720c43a21c3ab6352c1385f2e0fc90c13ce44282" => :mavericks
    sha256 "69f38749bff4448406e507d1f581235449db079ed01c629558ede737a1d7d6ec" => :mountain_lion
  end

  option :universal

  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  def install
    ENV.universal_binary if build.universal?

    system "make", "PREFIX=#{prefix}"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

class Enet < Formula
  desc "Provides a network communication layer on top of UDP"
  homepage "http://enet.bespin.org"
  url "http://enet.bespin.org/download/enet-1.3.13.tar.gz"
  sha256 "e36072021faa28731b08c15b1c3b5b91b911baf5f6abcc7fe4a6d425abada35c"

  bottle do
    cellar :any
    sha256 "14a3e5aebe4adb9a76c643a85a91e15c4815fec76697709a3d56f68c3921666e" => :yosemite
    sha256 "927255e6afb287eb95c6c7a53b275084229d3c11ad58066b824628e30a89dcea" => :mavericks
    sha256 "1f17395dd354ce630340a14ead424e539d3a42980fcc324ff8c4430bb34f4b3b" => :mountain_lion
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end
end

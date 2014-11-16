require "formula"

class SfPwgen < Formula
  homepage "https://bitbucket.org/anders/sf-pwgen/"
  url "https://bitbucket.org/anders/sf-pwgen/downloads/sf-pwgen-1.2.tar.gz"
  sha1 "7e8bc5e6c4f75ea9fbd904198a188264ff05837c"

  bottle do
    cellar :any
    sha1 "94cd1487d44fc74a8f8581889cfc91d4ebe16106" => :mavericks
    sha1 "6ae2fe533a617fca26f5bf665467f5bb1885f96b" => :mountain_lion
  end

  depends_on :macos => :mountain_lion

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    system "#{bin}/sf-pwgen", "-a", "memorable", "-c", "10", "-l", "20"
  end
end

require "formula"

class SfPwgen < Formula
  homepage "https://bitbucket.org/anders/sf-pwgen/"
  url "https://bitbucket.org/anders/sf-pwgen/downloads/sf-pwgen-1.2.tar.gz"
  sha1 "7e8bc5e6c4f75ea9fbd904198a188264ff05837c"

  depends_on :macos => :mountain_lion

  def install
    system "make"
    bin.install "sf-pwgen"
  end

  test do
    system "#{bin}/sf-pwgen", "-a", "memorable", "-c", "10", "-l", "20"
  end
end

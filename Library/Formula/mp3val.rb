class Mp3val < Formula
  desc "Program for MPEG audio stream validation"
  homepage "http://mp3val.sourceforge.net/"
  url "https://downloads.sourceforge.net/mp3val/mp3val-0.1.8-src.tar.gz"
  sha256 "95a16efe3c352bb31d23d68ee5cb8bb8ebd9868d3dcf0d84c96864f80c31c39f"

  bottle do
    cellar :any
    sha1 "a6fbb7ba9e3138c0badf0f4c8448193b4136b5a0" => :yosemite
    sha1 "0b07e20f77de64a0071899f49e329bf11fb29367" => :mavericks
    sha1 "997a608c91946b239e878c830a4be6336dbc5cb9" => :mountain_lion
  end

  def install
    system "gnumake", "-f", "Makefile.gcc"
    bin.install "mp3val.exe" => "mp3val"
  end

  test do
    mp3 = test_fixtures("test.mp3")
    assert_match(/Done!$/, shell_output("#{bin}/mp3val -f #{mp3}"))
  end
end

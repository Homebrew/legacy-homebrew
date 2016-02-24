class Mp3info < Formula
  desc "MP3 technical info viewer and ID3 1.x tag editor"
  homepage "https://www.ibiblio.org/mp3info/"
  url "https://www.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/mp3info-0.8.5a.tgz"
  sha256 "0438ac68e9f04947fb14ca5573d27c62454cb9db3a93b7f1d2c226cd3e0b4e10"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "30c85d8b2afd6e6ad03e473de3bd83ef9c6c607b979570798cfc778ad887b902" => :el_capitan
  end

  patch :p0 do
    url "https://raw.githubusercontent.com/Homebrew/patches/bedf6f8/mp3info/patch-mp3tech.c.diff"
    sha256 "846d6f85a3fa22908c6104436e774fc109547f7c6e9788c15dd9e602228b7892"
  end

  def install
    system "make", "mp3info", "doc"
    bin.install "mp3info"
    man1.install "mp3info.1"
  end

  test do
    system bin/"mp3info", "-x", test_fixtures("test.mp3")
  end
end

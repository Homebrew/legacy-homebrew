class Mp3info < Formula
  desc "MP3 technical info viewer and ID3 1.x tag editor"
  homepage "http://www.ibiblio.org/mp3info/"
  url "http://www.ibiblio.org/pub/linux/apps/sound/mp3-utils/mp3info/mp3info-0.8.5a.tgz"
  sha256 "0438ac68e9f04947fb14ca5573d27c62454cb9db3a93b7f1d2c226cd3e0b4e10"

  bottle do
    cellar :any
    sha1 "760a13887c10169cf2a3553b294a5ec4a7f8cf9f" => :yosemite
    sha1 "6cca8a83250afeba2e85a996c169865d09743d7e" => :mavericks
    sha1 "2f2840e15a53c1d3f52cced47d943604c7b6fdf9" => :mountain_lion
  end

  patch :p0 do
    url "https://trac.macports.org/export/34602/trunk/dports/audio/mp3info/files/patch-mp3tech.c.diff"
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

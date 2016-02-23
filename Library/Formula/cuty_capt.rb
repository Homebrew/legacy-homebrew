class CutyCapt < Formula
  desc "Converts web pages to vector/bitmap images using WebKit"
  homepage "http://cutycapt.sourceforge.net/"
  url "http://ftp.de.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz"
  version "0.0.6"
  sha256 "cf85226a25731aff644f87a4e40b8878154667a6725a4dc0d648d7ec2d842264"

  bottle do
    cellar :any
    sha256 "dc757b1c8e76ec43111f7eb8b232ed876b366a81f27ce53af1a828496eb8a8bb" => :el_capitan
    sha256 "0be50eae29e65d857d1c46e31ee611e58e4ab6d7a4f01720238b13ef12739d27" => :yosemite
    sha256 "bb1cc3c4e02ba780d9ba977445952c8bfa92e21eb5821a466beec0a376c45e43" => :mavericks
    sha256 "804e8194a1280f535be0851de27d66867f90ccf47167c3729a7ba3f87f73d9ff" => :mountain_lion
  end

  depends_on "qt"

  def install
    system "qmake", "CONFIG-=app_bundle"
    system "make"
    bin.install "CutyCapt"
  end

  test do
    system "#{bin}/CutyCapt", "--url=http://brew.sh", "--out=brew.png"
    assert File.exist? "brew.png"
  end
end

class CutyCapt < Formula
  desc "Converts web pages to vector/bitmap images using WebKit"
  homepage "http://cutycapt.sourceforge.net/"
  url "https://mirrorservice.org/sites/ftp.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz"
  version "0.0.6"
  sha256 "cf85226a25731aff644f87a4e40b8878154667a6725a4dc0d648d7ec2d842264"

  bottle do
    cellar :any
    revision 1
    sha256 "dc757b1c8e76ec43111f7eb8b232ed876b366a81f27ce53af1a828496eb8a8bb" => :el_capitan
    sha256 "f7fe4aa211334eef9b42ee7667d416607e57ba3c7c36a24a6ad01dbb49cb97e9" => :yosemite
    sha256 "1a4110195ff9d3837ed86b0ec73cc515c420cf07aa08ed00f5d8b1d9cae49dc3" => :mavericks
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

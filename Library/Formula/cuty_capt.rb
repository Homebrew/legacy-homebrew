class CutyCapt < Formula
  homepage "http://cutycapt.sourceforge.net/"
  url "http://ftp.de.debian.org/debian/pool/main/c/cutycapt/cutycapt_0.0~svn6.orig.tar.gz"
  version "0.0.6"
  sha256 "cf85226a25731aff644f87a4e40b8878154667a6725a4dc0d648d7ec2d842264"

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

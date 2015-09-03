class Treeline < Formula
  desc "Advanced outliner and personal information manager"
  homepage "http://treeline.bellz.org/"
  url "https://downloads.sourceforge.net/project/treeline/2.0.0/treeline-2.0.0.tar.gz"
  sha256 "71af995fca9e0eaf4e6205d72eb4ee6a979a45ea2a1f6600ed8a39bb1861d118"

  bottle do
    cellar :any
    sha256 "271f5380e8ab3bf777a20f8dd077462ac1768baf749c7625100a7aeddb067190" => :yosemite
    sha256 "f46d47da8720bd8cfbf54c14f5e0c2d6116be8d362d3eaebb5039f4996fb9800" => :mavericks
    sha256 "f37b950321dca64236f8844eee5f62ec9e6bca115dde0d17160e519b0dbf95fe" => :mountain_lion
  end

  depends_on :python3
  depends_on "sip" => "with-python3"
  depends_on "pyqt" => "with-python3"

  def install
    system "./install.py", "-p#{prefix}"
  end

  test do
    system bin/"treeline", "--help"
  end
end

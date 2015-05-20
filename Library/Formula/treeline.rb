class Treeline < Formula
  desc "Advanced outliner and personal information manager"
  homepage "http://treeline.bellz.org/"
  url "https://downloads.sourceforge.net/project/treeline/2.0.0/treeline-2.0.0.tar.gz"
  sha256 "71af995fca9e0eaf4e6205d72eb4ee6a979a45ea2a1f6600ed8a39bb1861d118"

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

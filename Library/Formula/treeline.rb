class Treeline < Formula
  desc "Advanced outliner and personal information manager"
  homepage "http://treeline.bellz.org/"
  url "https://downloads.sourceforge.net/project/treeline/1.4.1/treeline-1.4.1.tar.gz"
  sha256 "d66e0fcae9bcb5e54f664381f6af73f360f9ff46c91787a126c7197fbe685489"

  depends_on :python
  depends_on "pyqt"

  def install
    system "./install.py", "-p#{prefix}"
  end
end

class Leo < Formula
  homepage "http://leoeditor.com/"
  url "http://sourceforge.net/projects/leo/files/Leo/5.0-final/Leo-5.0-final.zip"
  sha256 "2d742f9825959ba5c7624d1179b9f3065e14e055c90272fbce199f91770de826"
  head "https://github.com/leo-editor/leo-editor", :using => :git

  depends_on "pyqt"
  depends_on "enchant" => :recommended
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    (lib+"python2.7/site-packages").install "leo"
    bin.install "launchLeo.py" => "leo"
  end

  test do
    system bin/"python", "-c", "import leo"
  end
end

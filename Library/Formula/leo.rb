class Leo < Formula
  homepage "http://leoeditor.com/"
  url "https://downloads.sourceforge.net/projects/leo/files/Leo/5.1-final/Leo-5.1-final.zip"
  sha256 "2d742f9825959ba5c7624d1179b9f3065e14e055c90272fbce199f91770de826"

  depends_on "pyqt"
  depends_on "enchant" => :recommended

  def install
    # Obtain information on Python installation
    python_xy = "python" + `%x(python -c "import sys;print(sys.version[:3])")`.chomp
    python_site_packages = lib + "#{python_xy}/site-packages"
    python_site_packages.install "leo"
    bin.install ["launchLeo.py", "profileLeo.py"]
    ln_s "#{bin}/launchLeo.py", "#{bin}/leo"
  end

  test do
    # Create, run in and delete a temporary directory.
    if system "python" "-c" "import leo"
      onoe "Leo FAILED"
    else
      ohai "Leo OK"
    end
  end
end

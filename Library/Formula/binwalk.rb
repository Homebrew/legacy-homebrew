require 'formula'

class Binwalk < Formula
  homepage 'http://code.google.com/p/binwalk/'
  url 'https://binwalk.googlecode.com/files/binwalk-1.2.1.tar.gz'
  sha1 '1c5830003ca8d4bcaa65c5ab31b858d46d4731fa'

  depends_on 'libmagic' => 'with-python'
  depends_on 'numpy' => :python
  depends_on 'matplotlib' => :python

  def install
    cd "src" do
      # In order to install into the Cellar, the dir must exist and be in the PYTHONPATH.
      temp_site_packages = lib/which_python/'site-packages'
      mkdir_p temp_site_packages
      ENV['PYTHONPATH'] = temp_site_packages

      args = [
        "--no-user-cfg",
        "--verbose",
        "install",
        "--force",
        "--install-scripts=#{bin}",
        "--install-lib=#{temp_site_packages}",
        "--install-data=#{share}",
        "--install-headers=#{include}",
      ]
      system "python", "setup.py", *args
    end
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

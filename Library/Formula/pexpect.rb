require 'formula'

class Pexpect < Formula
  homepage 'http://www.noah.org/python/pexpect/'
  url 'http://downloads.sourceforge.net/project/pexpect/pexpect/Release%202.3/pexpect-2.3.tar.gz'
  sha1 'ee1e2770bfe49e7651bab78357179c28ed99a55b'

  def install
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
      "--record=installed-files.txt"
    ]

    system "python", "-s", "setup.py", *args
  end

  def which_python
    "python" + `python -c 'import sys;print(sys.version[:3])'`.strip
  end
end

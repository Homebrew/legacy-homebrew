require 'formula'

class NinjaIde < Formula
  homepage 'http://ninja-ide.org/'
  url 'https://github.com/ninja-ide/ninja-ide/archive/v2.3.tar.gz'
  sha1 '64ccbbf8521a8fbef43c3d57cf616b7f8b466460'

  depends_on :python
  depends_on :python => ['fsevents' => 'MacFSEvents']
  depends_on 'pyqt'

  def install
    python do
      system python, "setup.py", "install", "--prefix=#{prefix}",
                     "--single-version-externally-managed", "--record=installed.txt"
    end
  end

  test do
    system "ninja-ide", "-h"
  end
end

require 'formula'

class NinjaIde < Formula
  homepage 'http://ninja-ide.org/'
  url 'https://github.com/ninja-ide/ninja-ide/archive/v2.3.tar.gz'
  sha1 '64ccbbf8521a8fbef43c3d57cf616b7f8b466460'

  depends_on :python
  depends_on "MacFSEvents" => [:python, "fsevents"]
  depends_on 'pyqt'

  def install
    system "python", "setup.py", "install", "--prefix=#{prefix}",
                     "--single-version-externally-managed", "--record=installed.txt"
    bin.env_script_all_files(libexec+'bin', :PYTHONPATH => ENV['PYTHONPATH'])
  end

  test do
    system bin/"ninja-ide", "-h"
  end
end

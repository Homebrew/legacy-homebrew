require 'formula'

class Slimerjs < Formula
  homepage 'http://www.slimerjs.org'
  url 'http://download.slimerjs.org/v0.8/0.8.4/slimerjs-0.8.4.zip'
  sha1 '89c7dc05b9df5f2aac0d423fb5a2118271ac9ad2'

  head 'https://github.com/laurentj/slimerjs.git'

  def install
    if build.head?
      cd 'src/'
      system 'zip -r omni.ja chrome/ components/ modules/ defaults/ chrome.manifest -x@package_exclude.lst'
    end
    libexec.install 'slimerjs.py' if build.head?
    libexec.install %w[application.ini omni.ja slimerjs]
    bin.install_symlink libexec/'slimerjs'
  end

  def caveats; <<-EOS.undent
    You should set the environment variable SLIMERJSLAUNCHER to a installation of Mozilla Firefox (or XULRunner).
    For a standard Mozilla Firefox installation this would be:
      export SLIMERJSLAUNCHER=/Applications/Firefox.app/Contents/MacOS/firefox
    EOS
  end
end

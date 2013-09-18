require 'formula'

class Slimerjs < Formula
  homepage 'http://www.slimerjs.org'
  url 'http://download.slimerjs.org/v0.8/slimerjs-0.8.3.zip'
  sha1 '8d2a6dc3b8200fa15cd9d65c84bc9358c11f03f8'

  head 'https://github.com/laurentj/slimerjs.git'

  def install
    if build.head?
      cd 'src/'
      # creating resource archive if build from head
      system 'zip -r omni.ja chrome/ components/ modules/ defaults/ chrome.manifest -x@package_exclude.lst'
    end
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

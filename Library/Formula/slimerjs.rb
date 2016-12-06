require 'formula'

class Slimerjs < Formula
  homepage 'http://www.slimerjs.org'
  url 'http://download.slimerjs.org/v0.8/slimerjs-0.8.2.zip'
  sha1 '18066ada8e3735f1a2722b104f13201c57136375'

  def install
    # fixed uname on os x as in upstream: https://github.com/laurentj/slimerjs/commit/05abb14
    inreplace 'slimerjs', 'uname -o', 'uname -o 2>&1'
    rm_rf 'slimerjs.bat'
    libexec.install Dir['*']
    bin.install_symlink libexec/'slimerjs'
  end

  def caveats; <<-EOS.undent
    You should set the environment variable SLIMERJSLAUNCHER to a installation of Mozilla Firefox (or XULRunner).
    For a standard Mozilla Firefox installation this would be:
      export SLIMERJSLAUNCHER=/Applications/Firefox.app/Contents/MacOS/firefox
    EOS
  end
end

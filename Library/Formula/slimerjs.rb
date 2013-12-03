require 'formula'

class Slimerjs < Formula
  homepage 'http://www.slimerjs.org'
  url 'http://download.slimerjs.org/v0.8/0.8.5/slimerjs-0.8.5.zip'
  sha1 '15ab47922d24806ed826325d7afdf0a18d2b342e'

  head 'https://github.com/laurentj/slimerjs.git'

  devel do
    url 'https://github.com/laurentj/slimerjs/archive/RELEASE_0.9.1rc1.tar.gz'
    sha1 '9fb0a3b2e4c44c8d48e9b436127ba2036099b93f'
    version '0.9.1rc1'
  end

  def install
    unless build.stable?
      cd 'src/'
      system 'zip -r omni.ja chrome/ components/ modules/ defaults/ chrome.manifest -x@package_exclude.lst'
      libexec.install 'slimerjs.py'
    end
    libexec.install %w[application.ini omni.ja slimerjs]
    bin.install_symlink libexec/'slimerjs'
  end

  def caveats; <<-EOS.undent
    You should set the SLIMERJSLAUNCHER environment variable to a installation of
    Mozilla Firefox (or Mozilla XULRunner).
    For a standard Mozilla Firefox installation this would be:

      export SLIMERJSLAUNCHER=/Applications/Firefox.app/Contents/MacOS/firefox

    Note: If you use SlimerJS with an unstable version of Mozilla Firefox/XULRunner
    (>24.0) you may have to change the [Gecko]MaxVersion in:
      #{libexec}/application.ini
    EOS
  end
end

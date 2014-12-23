require 'formula'

class Slimerjs < Formula
  homepage 'http://www.slimerjs.org'
  url "http://download.slimerjs.org/releases/0.9.4/slimerjs-0.9.4-mac.tar.bz2"
  sha256 "3c9c7d01c58796e56f5d5b73f643bd99ddafd4ef2b1cc246d9e3b78108aceb5e"

  head 'https://github.com/laurentj/slimerjs.git'

  bottle do
    cellar :any
    sha1 "2913341c917994a4c49d464b93a6aa25d12fc4d3" => :mavericks
    sha1 "8ffe412b951816b089246d8b3587a441aa7c973b" => :mountain_lion
  end

  if MacOS.version > :snow_leopard
    option "without-xulrunner", "Build without xulrunner (requires a installed Firefox)"
    depends_on "xulrunner" => :recommended
  end

  def install
    unless build.stable?
      cd "src"
      system "zip", "-r", "omni.ja", "chrome/", "components/", "modules/",
                    "defaults/", "chrome.manifest", "-x@package_exclude.lst"
    end
    libexec.install ["application.ini", "omni.ja", "slimerjs", "slimerjs.py"]
    bin.install_symlink libexec/"slimerjs"
  end

  def caveats; <<-EOS.undent
    You can set the environment variable SLIMERJSLAUNCHER to a installation of
    Mozilla Firefox (or Mozilla XULRunner) to use this version with SlimerJS instead
    of the one installed by Homebrew (this is required if build without xulrunner).
    For a standard Mozilla Firefox installation this would be:

      export SLIMERJSLAUNCHER=/Applications/Firefox.app/Contents/MacOS/firefox

    Note: If you use SlimerJS with an unstable version of Mozilla Firefox/XULRunner
    (>29.*) you may have to change the [Gecko]MaxVersion in:
      #{libexec}/application.ini
    EOS
  end

  test do
    system "#{bin}/slimerjs", "-v"
    curl "-O", "https://raw.githubusercontent.com/laurentj/slimerjs/ec1e53a/examples/phantomjs/loadspeed.js"
    system "#{bin}/slimerjs", "loadspeed.js", "https://www.google.com"
  end
end

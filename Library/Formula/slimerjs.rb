require 'formula'

class Slimerjs < Formula
  homepage 'http://www.slimerjs.org'
  url "http://download.slimerjs.org/v0.9/0.9.1/slimerjs-0.9.1.zip"
  sha1 "15eed855c462c5b7ff2502d028702dcebae797cd"

  head 'https://github.com/laurentj/slimerjs.git'

  bottle do
    cellar :any
    sha1 "f777909179024c69332199893897d30eb7c104d5" => :mavericks
    sha1 "00ffe91192f50232cde4169d2a80d5e950edeef5" => :mountain_lion
    sha1 "a05a67c5a7366bf6b1ef6de7dc74fb4f35c4d9cb" => :lion
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

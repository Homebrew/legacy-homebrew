class Slimerjs < Formula
  homepage "http://www.slimerjs.org"
  url "http://download.slimerjs.org/releases/0.9.5/slimerjs-0.9.5-mac.tar.bz2"
  sha256 "4333ae1c7898789c71b65ba5767cd1781290cdad36cb64d58ef289933482c81b"

  head "https://github.com/laurentj/slimerjs.git"

  bottle do
    cellar :any
    sha1 "77b0703ee315c809ea9a1307b88f0a622affeedc" => :mavericks
    sha1 "aa5654afdd8d2dc049878d2898b9fb7fa33911ab" => :mountain_lion
  end

  if MacOS.version > :snow_leopard
    option "without-xulrunner", "Build without xulrunner (requires a installed Firefox)"
    depends_on "xulrunner" => :recommended
  end

  def install
    cd "src" do
      system "zip", "-r", "omni.ja", "chrome/", "components/", "modules/",
                    "defaults/", "chrome.manifest", "-x@package_exclude.lst"
    end unless build.stable?
    libexec.install %w[application.ini omni.ja slimerjs slimerjs.py]
    bin.install_symlink libexec/"slimerjs"
  end

  def caveats; <<-EOS.undent
    You can set the environment variable SLIMERJSLAUNCHER to a installation of
    Mozilla Firefox (or Mozilla XULRunner) to use this version with SlimerJS
    instead of the one installed by Homebrew (this is required if built without
    xulrunner).
    For a standard Mozilla Firefox installation this would be:

      export SLIMERJSLAUNCHER=/Applications/Firefox.app/Contents/MacOS/firefox

    Note: If you use SlimerJS with an unstable version of Mozilla
    Firefox/XULRunner (>29.*) you may have to change the [Gecko]MaxVersion in:
      #{libexec}/application.ini
    EOS
  end

  test do
    if build.with?("xulrunner")
      system "#{bin}/slimerjs", "-v"
      system "#{bin}/slimerjs", "loadspeed.js", "https://www.google.com"
    end
  end
end

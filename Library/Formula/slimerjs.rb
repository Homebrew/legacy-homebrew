class FirefoxRequirement < Requirement
  fatal true
  default_formula "xulrunner" if MacOS.version < :yosemite

  def self.firefox_installation
    paths = ["~/Applications/FirefoxNightly.app", "~/Applications/Firefox.app",
             "/Applications/FirefoxNightly.app", "/Applications/Firefox.app",
             "~/Applications/FirefoxDeveloperEdition.app",
             "/Applications/FirefoxDeveloperEdition.app"]
    paths.find { |p| File.exist? File.expand_path(p) }
  end

  satisfy(:build_env => false) { Formula["xulrunner"].installed? || FirefoxRequirement.firefox_installation }

  def message
    "Firefox or xulrunner must be available."
  end
end

class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://download.slimerjs.org/releases/0.9.6/slimerjs-0.9.6-mac.tar.bz2"
  sha256 "5c3ba9a83328a54b1fc6a6106abdd6d6b2117768f36ad43b9b0230a3ad7113cd"
  head "https://github.com/laurentj/slimerjs.git"

  bottle do
    cellar :any
    sha256 "3b9baa7f71e4e3b3472faf8e30d8e21f4a4f54e24fb894d003cb4fe539a6db1a" => :mavericks
    sha256 "3607fb21371c48b903b5a0ed5c7211b027be3f76e7fbdccb6e44c30d5e341385" => :mountain_lion
  end

  devel do
    url "https://download.slimerjs.org/nightlies/latest-slimerjs-stable/slimerjs-0.9.7-pre-mac.tar.bz2"
    sha256 "8817a90333154ecb52415638d418e6d90d6742fec3d80f124b739344a75da5d1"
    version "0.9.7-pre"
  end

  # Min supported OS X version by Firefox & xulrunner is 10.6
  depends_on :macos => :leopard
  depends_on FirefoxRequirement

  def install
    if build.head?
      cd "src" do
        system "zip", "-r", "omni.ja", "chrome/", "components/", "modules/",
                      "defaults/", "chrome.manifest", "-x@package_exclude.lst"
        libexec.install %w[application.ini omni.ja slimerjs slimerjs.py]
      end
    else
      libexec.install %w[application.ini omni.ja slimerjs slimerjs.py]
    end
    bin.install_symlink libexec/"slimerjs"
  end

  def caveats
    s = ""

    if (firefox_installation = FirefoxRequirement.firefox_installation)
      s += <<-EOS.undent
        You MUST provide an installation of Mozilla Firefox and set
        the environment variable SLIMERJSLAUNCHER pointing to it, e.g.:

        export SLIMERJSLAUNCHER=#{firefox_installation}/Contents/MacOS/firefox
        EOS
    end
    s += <<-EOS.undent

      Note: If you use SlimerJS with an unstable version of Mozilla Firefox/XULRunner (>38.*)
      you may have to change the [Gecko]MaxVersion in #{libexec}/application.ini
    EOS

    s
  end

  test do
    if build.with?("xulrunner")
      system "#{bin}/slimerjs", "-v"
      system "#{bin}/slimerjs", "loadspeed.js", "https://www.google.com"
    end
  end
end

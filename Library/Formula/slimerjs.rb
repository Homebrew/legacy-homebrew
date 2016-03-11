class FirefoxRequirement < Requirement
  fatal true
  cask "firefox"

  def self.firefox_installation
    paths = ["~/Applications/FirefoxNightly.app", "~/Applications/Firefox.app",
             "/Applications/FirefoxNightly.app", "/Applications/Firefox.app",
             "~/Applications/FirefoxDeveloperEdition.app",
             "/Applications/FirefoxDeveloperEdition.app"]
    paths.find { |p| File.exist? File.expand_path(p) }
  end

  satisfy(:build_env => false) { FirefoxRequirement.firefox_installation }

  def message
    "Firefox must be available."
  end
end

class Slimerjs < Formula
  desc "Scriptable browser for Web developers"
  homepage "https://slimerjs.org/"
  url "https://download.slimerjs.org/releases/0.9.6/slimerjs-0.9.6.zip"
  sha256 "982526f734ae4005f6117b821c1703482f2bc87c6b2e3ceaae6b981d4d123e73"
  head "https://github.com/laurentj/slimerjs.git"

  devel do
    url "https://download.slimerjs.org/nightlies/latest-slimerjs-stable/slimerjs-0.9.7-pre.zip"
    version "0.9.7-pre"
    sha256 "c2228a163770ef95b41c971cf42fdbab42cf9fd9ee53d1d6891f8e1c3f50592d"
  end

  bottle :unneeded

  # Min supported OS X version by Firefox is 10.6.
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

      Note: If you use SlimerJS with an unstable version of Mozilla Firefox (>38.*)
      you may have to change the [Gecko]MaxVersion in #{libexec}/application.ini
    EOS

    s
  end

  test do
    ENV.delete "SLIMERJSLAUNCHER"
    assert_match "Set it with the path to Firefox", shell_output("#{bin}/slimerjs", 1)
  end
end

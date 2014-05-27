require "formula"

class MozillaAddonSdk < Formula
  homepage "https://developer.mozilla.org/en-US/Add-ons/SDK"
  url "http://ftp.mozilla.org/pub/mozilla.org/labs/jetpack/addon-sdk-1.16.zip"
  sha1 "75cae8e46f685e5d7995bb83a50ee2bdd8bec2cc"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/cfx"
  end
end

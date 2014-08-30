require "formula"

class MozillaAddonSdk < Formula
  homepage "https://developer.mozilla.org/en-US/Add-ons/SDK"
  url "http://ftp.mozilla.org/pub/mozilla.org/labs/jetpack/addon-sdk-1.17.zip"
  sha1 "f3f81edad79c10a8efc19520d16ed35afc0649ef"

  def install
    libexec.install Dir["*"]
    bin.install_symlink "#{libexec}/bin/cfx"
  end
end

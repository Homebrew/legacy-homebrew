require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://github.com/downloads/nathanmarz/storm/storm-0.7.4.zip'
  md5 '4d00cc826443fc2fc76514f3b688d656'

  def install
    libexec.install Dir['*']
    bin.install_symlink Dir["#{libexec}/bin/storm"]
  end
end

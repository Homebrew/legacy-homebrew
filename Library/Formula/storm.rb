require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://github.com/downloads/nathanmarz/storm/storm-0.8.1.zip'
  sha1 'ce5f5dad82f33b7189ce975e0741d1c57007ed0e'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end

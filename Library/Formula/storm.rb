require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'https://github.com/downloads/nathanmarz/storm/storm-0.7.4.zip'
  sha1 '1ee4ec917c52a49d8cc11b4d2e8b41b79c98f97a'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end

require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'http://mirror.olnevhost.net/pub/apache/storm/apache-storm-0.9.3/apache-storm-0.9.3.zip'
  sha1 'efccdca0babbcf36416f1229ee961639b234e53c'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end

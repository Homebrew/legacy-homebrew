require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'http://mirror.csclub.uwaterloo.ca/apache/incubator/storm/apache-storm-0.9.2-incubating/apache-storm-0.9.2-incubating.zip'
  sha1 '92536843d76463974dd7bce4f8694fa6e462f0b6'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end

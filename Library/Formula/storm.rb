require 'formula'

class Storm < Formula
  homepage 'https://github.com/nathanmarz/storm/wiki'
  url 'http://mirror.csclub.uwaterloo.ca/apache/incubator/storm/apache-storm-0.9.1-incubating/apache-storm-0.9.1-incubating.zip'
  version '0.9.1'
  sha1 '75f28e07fae2d21e427ba998b93069ef7dd3e184'

  def install
    libexec.install Dir['*']
    bin.install_symlink libexec/"bin/storm"
  end
end

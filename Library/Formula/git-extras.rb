require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/tarball/0.9.0'
  sha1 'ecb0492d50f896a2121d5709cfa2e5d67273e364'
  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    inreplace 'Makefile', '/usr/local', prefix
    inreplace 'Makefile', '/etc/bash_completion.d', "#{prefix}/etc/bash_completion.d"
    bin.mkpath
    system "make", "install"
  end
end

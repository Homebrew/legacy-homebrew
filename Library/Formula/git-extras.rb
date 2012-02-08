require 'formula'

class GitExtras < Formula
  homepage 'https://github.com/visionmedia/git-extras'
  url 'https://github.com/visionmedia/git-extras/tarball/0.9.0'
  sha1 'ecb0492d50f896a2121d5709cfa2e5d67273e364'
  head 'https://github.com/visionmedia/git-extras.git', :branch => 'master'

  def install
    inreplace 'Makefile' do |s|
      s.gsub! '/usr/local', prefix
      s.gsub! '/etc/bash_completion.d', "#{prefix}/etc/bash_completion.d"
    end
    bin.mkpath
    system "make", "install"
  end
end

require 'formula'

class GitMultipush < Formula
  homepage 'http://code.google.com/p/git-multipush/'
  url 'http://git-multipush.googlecode.com/files/git-multipush-2.3.tar.bz2'
  sha1 'a53f171af5e794afe9b1de6ccd9bd0661db6fd91'

  head 'https://github.com/gavinbeatty/git-multipush.git', :revision => 'HEAD'

  depends_on 'asciidoc' => :build if ARGV.build_head?

  def install
    if ARGV.build_head?
      ENV['GIT_DIR'] = cached_download/'.git'
      inreplace 'make/gen-version.mk', '.git', '$(GIT_DIR)'
      system "make"
    end
    system "make", "prefix=#{prefix}", "install"
  end
end

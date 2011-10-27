require 'formula'

class GitMultipush < Formula
  url 'http://git-multipush.googlecode.com/files/git-multipush-2.3.tar.bz2'
  homepage 'http://code.google.com/p/git-multipush/'
  sha1 'a53f171af5e794afe9b1de6ccd9bd0661db6fd91'
  head 'https://github.com/gavinbeatty/git-multipush.git', :sha => 'HEAD'

  depends_on 'asciidoc' => :build if ARGV.build_head?
  # Not depending on git because people might have it
  # installed through another means

  def install
    if ARGV.build_head?
      ENV['GIT_DIR'] = cached_download+'.git'
      inreplace 'make/gen-version.mk', '.git', '$(GIT_DIR)'
      system "make"
    end
    system "make", "prefix=#{prefix}", "install"
  end
end

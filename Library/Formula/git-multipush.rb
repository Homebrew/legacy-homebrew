require 'formula'

class GitMultipush < Formula
  homepage 'http://code.google.com/p/git-multipush/'
  url 'https://git-multipush.googlecode.com/files/git-multipush-2.3.tar.bz2'
  sha1 'a53f171af5e794afe9b1de6ccd9bd0661db6fd91'

  devel do
    url 'https://github.com/gavinbeatty/git-multipush/archive/git-multipush-v2.4.rc2.tar.gz'
    sha1 '7179bc729a1dee76a76e3c91935f524911037313'
    version '2.4-rc2'
  end

  head 'https://github.com/gavinbeatty/git-multipush.git'

  depends_on 'asciidoc' => :build

  def install
    if build.head?
      ENV['GIT_DIR'] = cached_download/'.git'
      inreplace 'make/gen-version.mk', '.git', '$(GIT_DIR)'
      system "make"
    end
    system "make", "prefix=#{prefix}", "install"
  end
end

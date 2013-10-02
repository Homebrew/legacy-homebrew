require 'formula'

class GitMultipush < Formula
  homepage 'https://github.com/gavinbeatty/git-multipush'
  url 'https://github.com/gavinbeatty/git-multipush/archive/git-multipush-v2.4.rc2.tar.gz'
  sha1 'a2c7873d773daff7d14ebfd66f80c464a219a332'

  head do
    url 'https://github.com/gavinbeatty/git-multipush.git'
    depends_on 'asciidoc' => :build
  end

  def install
    if build.head?
      ENV['GIT_DIR'] = cached_download/'.git'
      inreplace 'make/gen-version.mk', '.git', '$(GIT_DIR)'
      system "make"
    end
    system "make", "prefix=#{prefix}", "install"
  end
end

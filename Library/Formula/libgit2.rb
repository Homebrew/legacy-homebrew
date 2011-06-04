require 'formula'

class Libgit2 < Formula
  url 'https://github.com/libgit2/libgit2/zipball/v0.12.0'
  md5 '70073b25de4cca873cf565f81023f426'
  homepage 'http://libgit2.github.com/'

  head 'https://github.com/libgit2/libgit2.git', :branch => 'master'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build-static"
    system "./waf", "build-shared"
    system "./waf", "install"
  end
end

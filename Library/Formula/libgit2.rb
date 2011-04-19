require 'formula'

class Libgit2 < Formula
  url 'https://github.com/libgit2/libgit2/zipball/v0.11.0'
  md5 '3205234f5a6526415edafaad373d897a'
  homepage 'http://libgit2.github.com/'

  head 'git://github.com/libgit2/libgit2.git', :branch => 'master'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build-static"
    system "./waf", "build-shared"
    system "./waf", "install"
  end
end

require 'formula'

class Libgit2 <Formula
  url 'https://github.com/libgit2/libgit2/tarball/v0.2.0'
  md5 '753cbd61671663874d431b4292bcd4bb'
  homepage 'http://libgit2.github.com/'

  head 'https://github.com/libgit2/libgit2.git'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build-static"
    system "./waf", "build-shared"
    system "./waf", "install"
  end
end

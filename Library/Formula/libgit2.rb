require 'formula'

class Libgit2 <Formula
  url 'https://github.com/libgit2/libgit2/tarball/v0.1.0'
  md5 '88bf140e7148a90f4e0621a25c3b0551'
  homepage 'http://libgit2.github.com/'

  head 'https://github.com/libgit2/libgit2.git'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build-static"
    system "./waf", "build-shared"
    system "./waf", "install"
  end
end

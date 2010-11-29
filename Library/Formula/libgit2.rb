require 'formula'

class Libgit2 <Formula
  url 'http://download.github.com/libgit2-libgit2-v0.1.0-0-gc5b97d5.tar.gz'
  version '0.1.0'
  homepage 'http://libgit2.github.com/'
  md5 '88bf140e7148a90f4e0621a25c3b0551'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build-static"
    system "./waf", "build-shared"
    system "./waf", "install"
  end
end

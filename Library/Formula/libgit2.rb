require 'formula'

class Libgit2 <Formula
  url 'https://github.com/libgit2/libgit2/tarball/v0.3.0'
  md5 'ae156dfa1db98ca046b23542e91d0f27'
  homepage 'http://libgit2.github.com/'

  head 'git://github.com/libgit2/libgit2.git', :branch => 'master'

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build-static"
    system "./waf", "build-shared"
    system "./waf", "install"
  end
end

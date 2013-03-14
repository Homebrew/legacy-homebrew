require 'formula'

class Libmonome < Formula
  homepage 'http://illest.net/libmonome/'
  url 'https://github.com/monome/libmonome/tarball/1.2'
  sha1 '91ed3f7246e2f9462ff43c257fae5e34006a4c85'

  head 'https://github.com/monome/libmonome.git'

  depends_on 'liblo'

  fails_with :clang do
    cause 'waf fails to find g++ when compiling with clang'
  end

  def install
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end

end

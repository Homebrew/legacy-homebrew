require 'formula'

class Libmonome < Formula
  homepage 'http://illest.net/libmonome/'
  url 'https://github.com/monome/libmonome/archive/1.2.tar.gz'
  sha1 'a53a232a7b24614c865b7cb536f80cb0219ff1d1'

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

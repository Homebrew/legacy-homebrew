require 'formula'

class Libmonome < Formula
  url 'https://github.com/monome/libmonome/tarball/1.2'
  head 'https://github.com/monome/libmonome.git'
  homepage 'http://illest.net/libmonome/'
  md5 'aae0db94dd3cb0358f76e52089292b49'
  version '1.2'
  depends_on 'liblo'

  def install
    ENV['CC'] = '/usr/bin/gcc'
    system "./waf configure --prefix=#{prefix}"
    system "./waf build"
    system "./waf install"
  end

end

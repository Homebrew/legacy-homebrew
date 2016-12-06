require 'formula'

class Gjstest < Formula
  url 'http://google-js-test.googlecode.com/files/gjstest-1.0.2.tar.bz2'
  homepage 'http://code.google.com/p/google-js-test/'
  sha1 'a78b478912d1f1f28f900bbab4e44a4d1a9fbcde'

  depends_on 'gflags'
  depends_on 'glog'
  depends_on 'protobuf'
  depends_on 're2'
  depends_on 'v8'

  def install
    raise 'gjstest requires Snow Leopard or above.' unless MacOS.snow_leopard?

    system "make PREFIX=#{prefix}"
    system "make PREFIX=#{prefix} install"
  end
end

require 'formula'

class GoogleJsTest < Formula
  url 'http://google-js-test.googlecode.com/files/gjstest-1.0.4.tar.bz2'
  homepage 'http://code.google.com/p/google-js-test/'
  sha1 '7ec7c557d6f9aac96910509c8bdb917ebd7383ad'

  depends_on 'gflags'
  depends_on 'glog'
  depends_on 'protobuf'
  depends_on 're2'
  depends_on 'v8'

  def install
    raise 'gjstest requires Snow Leopard or above.' if MacOS.leopard?

    system "make PREFIX=#{prefix}"
    system "make PREFIX=#{prefix} install"
  end
end

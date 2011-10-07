require 'formula'

class GoogleJsTest < Formula
  url 'http://google-js-test.googlecode.com/files/gjstest-1.0.5.tar.bz2'
  homepage 'http://code.google.com/p/google-js-test/'
  sha1 '0314b4ed97ac19be7637c3e2735a81eb4a30e66e'

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

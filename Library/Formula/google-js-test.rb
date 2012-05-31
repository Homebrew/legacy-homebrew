require 'formula'

class NeedsSnowLeopard < Requirement
  def message
    "Google JS Test requires Mac OS X 10.6 (Snow Leopard) or newer."
  end

  def satisfied?
    MacOS.snow_leopard?
  end
end

class GoogleJsTest < Formula
  homepage 'http://code.google.com/p/google-js-test/'
  url 'http://google-js-test.googlecode.com/files/gjstest-1.0.7.tar.bz2'
  sha1 '8580cfe9c3ed2eca6e3c076bfc321048a6e4dd64'

  depends_on NeedsSnowLeopard.new
  depends_on 'gflags'
  depends_on 'glog'
  depends_on 'protobuf'
  depends_on 're2'
  depends_on 'v8'

  def install
    system "make", "PREFIX=#{prefix}"
    system "make", "PREFIX=#{prefix}", "install"
  end
end

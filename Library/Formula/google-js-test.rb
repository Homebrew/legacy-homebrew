require 'formula'

class NeedsSnowLeopard < Requirement
  def message
    "Google JS Test requires Mac OS X 10.6 (Snow Leopard) or newer."
  end

  def satisfied?
    MacOS.version >= :snow_leopard
  end
end

class GoogleJsTest < Formula
  homepage 'http://code.google.com/p/google-js-test/'
  url 'http://google-js-test.googlecode.com/files/gjstest-1.0.8.tar.bz2'
  sha1 '2209dd0c700f9420e29a844920f8614e3d97156d'

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

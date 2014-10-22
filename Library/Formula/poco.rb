require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'http://pocoproject.org/releases/poco-1.4.7/poco-1.4.7-all.tar.gz'
  sha1 '778bd5fca9d4169a2dd83265bc07123bd0d12273'
  version '1.4.7-all'

  devel do
    url 'http://pocoproject.org/releases/poco-1.5.4/poco-1.5.4-all.tar.gz'
    sha1 'd7f14c49472c4f333fe99d43cac021e90d24b024'
  end

  option :cxx11

  depends_on "openssl"

  def install
    ENV.cxx11 if build.cxx11?

    arch = Hardware.is_64_bit? ? 'Darwin64': 'Darwin32'
    arch << '-clang' if ENV.compiler == :clang

    system "./configure", "--prefix=#{prefix}",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--no-samples",
                          "--no-tests"
    system "make", "install", "CC=#{ENV.cc}", "CXX=#{ENV.cxx}"
  end
end

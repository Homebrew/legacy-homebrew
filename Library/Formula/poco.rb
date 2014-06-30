require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'http://pocoproject.org/releases/poco-1.4.6/poco-1.4.6p4-all.tar.gz'
  sha1 'a74f5d4a5a1b9218adcb3e3e9bc81f5377200c3e'
  version '1.4.6p4-all'

  devel do
    url 'http://pocoproject.org/releases/poco-1.5.2/poco-1.5.2-all.tar.bz2'
    sha1 'e2256795b13c0b77d20283cf64914d59245e3492'
  end

  option :cxx11

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

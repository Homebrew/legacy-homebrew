require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'https://github.com/downloads/pocoproject/poco/poco-1.4.5.tar.gz'
  sha1 'fd19d6d25504f9cdaf345880ddf64aa688dea170'

  def install
    arch = Hardware.is_64_bit? ? 'Darwin64': 'Darwin32'
    arch << '-clang' if ENV.compiler == :clang

    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--no-samples",
                          "--no-tests"
    system "make install CC=#{ENV.cc} CXX=#{ENV.cxx}"
  end
end

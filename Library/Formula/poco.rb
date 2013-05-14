require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'http://pocoproject.org/releases/poco-1.4.6/poco-1.4.6p1-all.tar.bz2'
  sha1 'c667c97b57d3f56b2884237a43d701b63e2be1f5'
  version '1.4.6p1-all'

  devel do
    url 'http://pocoproject.org/releases/poco-1.5.1/poco-1.5.1-all.tar.bz2'
    sha1 '2eaa44deb853a6f7ba7d9e4726a365ae45006ef1'
  end

  def install
    arch = Hardware.is_64_bit? ? 'Darwin64': 'Darwin32'
    arch << '-clang' if ENV.compiler == :clang

    system "./configure", "--prefix=#{prefix}",
                          "--config=#{arch}",
                          "--omit=Data/MySQL,Data/ODBC",
                          "--no-samples",
                          "--no-tests"
    system "make install CC=#{ENV.cc} CXX=#{ENV.cxx}"
  end
end

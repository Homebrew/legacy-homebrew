require 'formula'

class Poco < Formula
  homepage 'http://pocoproject.org/'
  url 'http://pocoproject.org/releases/poco-1.4.6/poco-1.4.6p1.tar.bz2'
  sha1 'b894b1bf2275cf53d2d246c43567b9bbeee7959e'
  version '1.4.6p1'

  devel do
    url 'http://pocoproject.org/releases/poco-1.5.1/poco-1.5.1.tar.bz2'
    sha1 'bb8362aa868e6ac1d671167f1d88649c86f1a5e4'
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

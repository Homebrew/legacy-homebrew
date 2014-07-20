require "formula"

class ActivemqCpp < Formula
  homepage "http://activemq.apache.org/cms/index.html"
  url "http://www.apache.org/dyn/closer.cgi?path=activemq/activemq-cpp/3.8.2/activemq-cpp-library-3.8.2-src.tar.bz2"
  sha1 "6fcaeb278f2d359343ccef4b5814f0092a4d7b54"

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

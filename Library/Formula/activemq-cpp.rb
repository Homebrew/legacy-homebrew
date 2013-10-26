require 'formula'

class ActivemqCpp < Formula
  homepage 'http://activemq.apache.org/cms/index.html'
  url 'http://apache.dattatec.com/activemq/activemq-cpp/source/activemq-cpp-library-3.8.1-src.tar.bz2'
  sha1 'd82d6c647d507ef4a44e28665f68def7a79e5b1d'

  depends_on 'autogen' => :build
  depends_on :autoconf
  depends_on :automake
  depends_on :libtool


  def install
    system "bash autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

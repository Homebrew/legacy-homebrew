require 'formula'

class ActivemqCpp < Formula
  homepage 'http://activemq.apache.org/cms/index.html'
  url 'http://apache.dattatec.com/activemq/activemq-cpp/source/activemq-cpp-library-3.8.2-src.tar.bz2'
  sha1 '6fcaeb278f2d359343ccef4b5814f0092a4d7b54'

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

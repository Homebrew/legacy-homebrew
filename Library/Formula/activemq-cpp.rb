require 'formula'

class ActivemqCpp < Formula
  url 'http://apache.dattatec.com/activemq/activemq-cpp/source/activemq-cpp-library-3.7.1-src.tar.bz2'
  homepage 'http://activemq.apache.org/cms/index.html'
  sha1 'e70167a0dc4f6c645c1e16a9c4e3fd95d208adf5'

  depends_on 'autogen' => :build
  depends_on 'autoconf' => :build
  depends_on 'automake' => :build
  depends_on 'libtool' => :build
  
 
  def install
    system "bash autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

require 'formula'

class ActivemqCpp <Formula
  url 'http://ftp.unicamp.br/pub/apache/activemq/activemq-cpp/source/activemq-cpp-2.2.6-src.tar.gz'
  homepage 'http://activemq.apache.org/cms/index.html'
  md5 '1222f0d6c5f86ef3ed5a558a533c7564'

 depends_on 'apr-util'

  def install
    system "bash autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"    
  end
end

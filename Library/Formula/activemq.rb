require 'formula'

class Activemq <Formula
  url 'http://www.apache.org/dist/activemq/apache-activemq/5.3.0/apache-activemq-5.3.0-bin.tar.gz'
  homepage 'http://activemq.apache.org/'
  md5 'f4b88a2b4ffd21cb804cdbd4f2e0152f'
  
  def install
    prefix.install Dir['*']

    # this tar comes with linux binaries as well, so lets make macosx the default
    macosx = bin+'macosx'
    bin.install macosx.children
    (bin+'linux-x86-64').rmtree
    (bin+'linux-x86-32').rmtree
    macosx.rmdir
  end
end

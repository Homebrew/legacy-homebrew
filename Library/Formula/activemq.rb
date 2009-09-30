require 'brewkit'

class Activemq <Formula
  @url='http://www.apache.org/dist/activemq/apache-activemq/5.2.0/apache-activemq-5.2.0-bin.tar.gz'
  @homepage='http://activemq.apache.org/'
  @md5='f11ca54e89689a0570dd607528966ba5'
  
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

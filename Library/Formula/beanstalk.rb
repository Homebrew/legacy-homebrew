require 'brewkit'

# TODO alias: beanstalkd

class Beanstalk <Formula
  url 'http://xph.us/dist/beanstalkd/beanstalkd-1.4.tar.gz'
  md5 'eea47c86c722c4448087fb28be7357cd'
  homepage 'http://xph.us/software/beanstalkd/'

  depends_on 'libevent'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking"
    system "make install"
  end
end

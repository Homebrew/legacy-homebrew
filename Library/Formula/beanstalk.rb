require 'formula'

class Beanstalk <Formula
  url 'http://xph.us/dist/beanstalkd/beanstalkd-1.4.4.tar.gz'
  md5 '094cd096c73904675e4ea7ccf5ce4b66'
  homepage 'http://xph.us/software/beanstalkd/'

  depends_on 'libevent'

  aka 'beanstalkd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-event=#{HOMEBREW_PREFIX}"

    system "make install"
  end
end

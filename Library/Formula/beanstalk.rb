require 'formula'

class Beanstalk <Formula
  url 'http://xph.us/dist/beanstalkd/beanstalkd-1.4.tar.gz'
  md5 'eea47c86c722c4448087fb28be7357cd'
  homepage 'http://xph.us/software/beanstalkd/'

  depends_on 'libevent'

  aka 'beanstalkd'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-event=#{HOMEBREW_PREFIX}"

    system "make install"
  end
end

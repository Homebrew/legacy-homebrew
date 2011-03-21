require 'formula'

class Beanstalk < Formula
  url 'http://xph.us/dist/beanstalkd/beanstalkd-1.4.6.tar.gz'
  md5 '3dbbb64a6528efaaaa841ea83b30768e'
  homepage 'http://xph.us/software/beanstalkd/'

  depends_on 'libevent'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-event=#{HOMEBREW_PREFIX}"

    system "make install"
  end
end

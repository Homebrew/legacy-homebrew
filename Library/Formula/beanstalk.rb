require 'formula'

class Beanstalk < Formula
  homepage 'http://kr.github.com/beanstalkd/'
  url 'https://github.com/downloads/kr/beanstalkd/beanstalkd-1.6.tar.gz'
  md5 '844cb7790e2a7ccfc08629dbc2b73178'

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end

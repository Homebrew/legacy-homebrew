require 'formula'

class Beanstalk < Formula
  url 'https://github.com/downloads/kr/beanstalkd/beanstalkd-1.5.tar.gz'
  md5 'd75a0a93e6b80b57fea61136f6da57eb'
  homepage 'http://kr.github.com/beanstalkd/'

  def install
    system "make install PREFIX=#{prefix}"
  end
end

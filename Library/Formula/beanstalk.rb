require 'formula'

class Beanstalk < Formula
  homepage 'http://kr.github.com/beanstalkd/'
  url 'https://github.com/downloads/kr/beanstalkd/beanstalkd-1.5.tar.gz'
  md5 'd75a0a93e6b80b57fea61136f6da57eb'

  # fix cpu use on freebsd and darwin
  # bug report: https://github.com/kr/beanstalkd/issues/96
  # Will be in next release
  def patches
    "http://github.com/kr/beanstalkd/commit/80da772efeeaabb12893f52a93da74ca9e69206d.patch"
  end

  def install
    system "make", "install", "PREFIX=#{prefix}"
  end
end

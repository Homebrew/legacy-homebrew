require 'formula'

class Beanstalk < Formula
  url 'https://github.com/downloads/kr/beanstalkd/beanstalkd-1.4.6.tar.gz'
  md5 '3dbbb64a6528efaaaa841ea83b30768e'
  homepage 'http://kr.github.com/beanstalkd/'

  depends_on 'libevent'

  # Patch from upstream to compile against libevent 2.x. See:
  # https://github.com/kr/beanstalkd/commit/976ec8ba8e70e3b5027f441de529f479c11c8507#diff-0
  # https://github.com/kr/beanstalkd/issues/49
  def patches
    "https://github.com/kr/beanstalkd/commit/976ec8ba8e70e3b5027f441de529f479c11c8507.patch"
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-event=#{HOMEBREW_PREFIX}"

    system "make install"
  end
end

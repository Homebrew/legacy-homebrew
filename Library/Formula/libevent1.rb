require 'formula'

class Libevent1 < Formula
  homepage 'http://libevent.org/'
  url 'https://github.com/downloads/libevent/libevent/libevent-1.4.14b-stable.tar.gz'
  sha1 '4a834364c28ad652ddeb00b5f83872506eede7d4'

  keg_only 'It is an older version that would clash with the widely used libevent-2'

  def install
    system "./configure --prefix=#{prefix}"
    system 'make install'
  end
end

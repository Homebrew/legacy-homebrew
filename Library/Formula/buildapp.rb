require 'formula'

class Buildapp < Formula
  homepage 'http://www.xach.com/lisp/buildapp/'
  url 'https://github.com/xach/buildapp/archive/release-1.4.8.tar.gz'
  sha1 '2a0b045d6b39976331c918607c38f49353a81e43'

  depends_on 'sbcl'

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end
end

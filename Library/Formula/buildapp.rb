require 'formula'

class Buildapp < Formula
  homepage 'http://www.xach.com/lisp/buildapp/'
  url 'https://github.com/xach/buildapp/archive/release-1.5.1.tar.gz'
  sha1 '164377c4cf7f23e69d80d55cbd7a0db028ae97d5'

  depends_on 'sbcl'

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end
end

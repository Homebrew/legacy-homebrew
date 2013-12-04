require 'formula'

class Buildapp < Formula
  homepage 'http://www.xach.com/lisp/buildapp/'
  url 'https://github.com/xach/buildapp/archive/release-1.5.tar.gz'
  sha1 '080acc59c686ac6a2a663a09340924592687966c'

  depends_on 'sbcl'

  def install
    bin.mkpath
    system "make", "install", "DESTDIR=#{prefix}"
  end
end

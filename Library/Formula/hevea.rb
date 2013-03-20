require 'formula'

class Hevea < Formula
  homepage 'http://hevea.inria.fr/'
  url 'http://hevea.inria.fr/distri/hevea-2.04.tar.gz'
  sha1 'f3d333bea7cda67cd95ca39f0039d82d1f732719'

  depends_on 'objective-caml'
  depends_on 'ghostscript' => :optional

  def install
    inreplace 'Makefile', '/usr/local', prefix
    system "make"
    system "make install"
  end
end

require 'formula'

class Hevea < Formula
  homepage 'http://hevea.inria.fr/'
  url 'http://hevea.inria.fr/distri/hevea-2.13.tar.gz'
  sha1 '03b35732f880591743ba750948b14efc0a46578b'

  bottle do
    sha1 "35761f7de7166b14412443c701386581209ac61b" => :mavericks
    sha1 "ac0e2b98c81f462a7df9a07e2fb38754f922d573" => :mountain_lion
    sha1 "a86c833a0ffeb1f46917f529895546fdda604261" => :lion
  end

  depends_on 'objective-caml'
  depends_on 'ghostscript' => :optional

  def install
    inreplace 'Makefile', '/usr/local', prefix
    system "make"
    system "make install"
  end
end

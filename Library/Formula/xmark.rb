require 'formula'

class Xmark < Formula
  url 'http://www.ins.cwi.nl/projects/xmark/Assets/unix.c'
  homepage 'http://www.xml-benchmark.org/'
  md5 'a27a4fbf3f10d29a43f965a640eedba1'
  version '0.92'

  def install
    system "gcc -o xmark unix.c"
	bin.install('xmark')
  end
end

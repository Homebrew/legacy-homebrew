require 'formula'

class Yamdi < Formula
  url 'http://downloads.sourceforge.net/project/yamdi/yamdi/1.6/yamdi-1.6.tar.gz'
  homepage 'http://yamdi.sourceforge.net/'
  md5 '3f8395373e941f235015a92d4da047c8'

  def install
    system "gcc yamdi.c -o yamdi -O2 -Wall"
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end

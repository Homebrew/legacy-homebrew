require 'formula'

class Yamdi < Formula
  homepage 'http://yamdi.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/yamdi/yamdi/1.8/yamdi-1.8.tar.gz'
  md5 '7562f6e28247013cd09e62c4c91272d5'

  def install
    system "#{ENV.cc} #{ENV.cflags} yamdi.c -o yamdi"
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end

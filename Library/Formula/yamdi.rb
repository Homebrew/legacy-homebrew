require 'formula'

class Yamdi < Formula
  homepage 'http://yamdi.sourceforge.net/'
  url 'http://sourceforge.net/projects/yamdi/files/yamdi/1.9/yamdi-1.9.tar.gz'
  sha1 '921d23f3059fa21319b74de945bb7cf565e2d67e'

  def install
    system "#{ENV.cc} #{ENV.cflags} yamdi.c -o yamdi"
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end

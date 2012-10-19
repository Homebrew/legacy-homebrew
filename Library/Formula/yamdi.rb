require 'formula'

class Yamdi < Formula
  homepage 'http://yamdi.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/yamdi/yamdi/1.8/yamdi-1.8.tar.gz'
  sha1 'daea2b7262ba1278a62525dafd3e8366d72fe2c3'

  def install
    system "#{ENV.cc} #{ENV.cflags} yamdi.c -o yamdi"
    bin.install "yamdi"
    man1.install "man1/yamdi.1"
  end
end

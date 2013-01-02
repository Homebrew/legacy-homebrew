require 'formula'

class Aescrypt < Formula
  homepage 'http://aescrypt.sourceforge.net/'
  url 'http://aescrypt.sourceforge.net/aescrypt-0.7.tar.gz'
  sha1 '72756ccccd43a4f19796835395512616c86c273f'

  def install
    system "./configure"
    system "make"
    bin.install 'aescrypt', 'aesget'
  end
end

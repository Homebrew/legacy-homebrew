require 'formula'

class Duti < Formula
  homepage 'http://duti.org/'
  url 'https://github.com/downloads/fitterhappier/duti/duti-1.5.1.tar.gz'
  sha1 'ac199f936180a3ac62100ae9a31e107a45330557'
  head 'https://github.com/fitterhappier/duti.git'


  def install
    system "./configure", "--prefix=#{prefix}"
    system "make install"
  end

  def test
    system "#{bin}/duti", "-x", "txt"
  end
end

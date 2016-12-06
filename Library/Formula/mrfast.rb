require 'formula'

class Mrfast < Formula
  homepage 'http://mrfast.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/mrfast/mrfast/mrfast-2.1.0.3.tar.gz'
  md5 '32dfbfae84852ed7847fec0155cb55aa'

  def install
    system "make"
    bin.install('mrfast')
  end

  def test
    system "#{bin}/mrfast -v"
  end
end

require 'formula'

class Figtoipe < Formula
  homepage 'http://ipe7.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/ipe7/tools/figtoipe-20091205.tar.gz'
  sha1 'b81f2f0cc568e165bdedb618ced9384ebfcb19a3'

  def install
    system "make"
    bin.install "figtoipe"
    man1.install "figtoipe.1"
    doc.install "README"
  end
end

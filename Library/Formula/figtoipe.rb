require 'formula'

class Figtoipe < Formula
  url 'http://downloads.sourceforge.net/project/ipe7/tools/figtoipe-20091205.tar.gz'
  homepage 'http://ipe7.sourceforge.net/'
  md5 'a19e0712df137939c37c194b551da6b8'

  def install
    system "make"
    bin.install "figtoipe"
    man1.install "figtoipe.1"
    doc.install "README"
  end
end

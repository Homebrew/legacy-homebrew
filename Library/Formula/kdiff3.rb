require 'formula'

class Kdiff3 < Formula
  url 'http://downloads.sourceforge.net/project/kdiff3/kdiff3/0.9.96/kdiff3-0.9.96.tar.gz'
  homepage 'http://kdiff3.sourceforge.net/'
  md5 '46b96befddf3448a3cb673f018c6f6f9'

  depends_on 'qt'

  def install
    # configure builds the binary
    system "./configure", "qt4"
    bin.install "src-QT4/kdiff3.app/Contents/MacOS/kdiff3"
  end
end

require 'formula'

class Gabedit < Formula
  homepage 'http://gabedit.sourceforge.net/'
  url 'http://downloads.sourceforge.net/project/gabedit/gabedit/Gabedit240/GabeditSrc240.tar.gz'
  md5 '2b012ceaacafffc92c5d677822df8002'
  version '2.4.0'

  depends_on 'gtk+'
  depends_on 'gtkglext'

  def install
    # INSTALL recommends copying over CONFIG file from platform/, but the
    # default one works well so we won't do it.
    system 'make'

    # There is no 'make install' so install manually
    bin.install 'gabedit'
  end

  def test
    system 'gabedit'
  end
end

require 'formula'

class Qwt <Formula
  url 'http://downloads.sourceforge.net/project/qwt/qwt/5.1.2/qwt-5.1.2.tar.bz2'
  homepage 'http://qwt.sourceforge.net/'
  md5 'cb26a36f020d7c038e207b03b7d79bc5'

  depends_on 'qt'

  def install
    ENV.j1
    inreplace 'qwtconfig.pri', '    INSTALLBASE    = /usr/local/qwt-5.1.2',
                               "    INSTALLBASE    = #{prefix}"
    system "qmake -config release"
    system "make install"
  end
end

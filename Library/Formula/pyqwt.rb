require 'formula'

class Pyqwt < Formula
  url 'http://sourceforge.net/projects/pyqwt/files/pyqwt5/PyQwt-5.2.0/PyQwt-5.2.0.tar.gz'
  homepage 'http://pyqwt.sourceforge.net/'
  md5 'fcd6c6029090d473dcc9df497516eae7'

  depends_on 'qt'
  depends_on 'qwt'
  depends_on 'sip'

  def install
    cd "configure" do
      system "python",
             "configure.py",
             "--module-install-path=#{lib}/python/Qwt",
             "-Q", "../qwt-5.2"
      system "make install"
    end
  end

  def test
    system "test -e /usr/local/lib/python/Qwt/"
  end
end

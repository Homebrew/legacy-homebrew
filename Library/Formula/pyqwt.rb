require 'formula'

class Pyqwt < Formula
  url 'http://downloads.sourceforge.net/project/pyqwt/pyqwt5/PyQwt-5.2.0/PyQwt-5.2.0.tar.gz'
  homepage 'http://http://pyqwt.sourceforge.net/'
  md5 'fcd6c6029090d473dcc9df497516eae7'

  depends_on 'qt'
  depends_on 'sip'
  depends_on 'pyqt'

  def install
    Dir.chdir 'configure' do
      system "python", "configure.py", "-4", "--qwt-sources=../qwt-5.2"
      system "make"
      system "make install"
    end
  end
end

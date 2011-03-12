require 'formula'

class Qwt <Formula
  url 'http://sourceforge.net/projects/qwt/files/qwt/5.2.1/qwt-5.2.1.tar.bz2'
  homepage 'http://qwt.sourceforge.net/'
  md5 '4a595b8db0ec3856b117836c1d60cb27'

  depends_on 'qt'

  def install
    inreplace 'qwtconfig.pri' do |s|
      s.gsub! /\/usr\/local\/qwt-5\.2\.1/, prefix
    end

    system "qmake -config release"
    system "make install"
  end
end

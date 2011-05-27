require 'formula'

class Qwt < Formula
  homepage 'http://qwt.sourceforge.net/'

  #url 'http://sourceforge.net/projects/qwt/files/qwt/6.0.0/qwt-6.0.0.tar.bz2'
  #md5 '1795cf075ebce3ae048255d2060cbac0'

  url 'http://sourceforge.net/projects/qwt/files/qwt/5.2.1/qwt-5.2.1.tar.bz2'
  md5 '4a595b8db0ec3856b117836c1d60cb27'

  depends_on 'qt'

  def install
    inreplace 'qwtconfig.pri' do |s|
      # QWT6:
      ## change_make_var won't work because there are leading spaces
      #s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"

      # QWT5:
      s.gsub! /\/usr\/local\/qwt-5\.2\.1/, prefix
    end

    system "qmake -config release"
    system "make install"
  end
end

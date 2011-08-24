require 'formula'

class Qwt < Formula
  url 'http://sourceforge.net/projects/qwt/files/qwt/6.0.0/qwt-6.0.0.tar.bz2'
  homepage 'http://qwt.sourceforge.net/'
  md5 '1795cf075ebce3ae048255d2060cbac0'

  depends_on 'qt'

  def install
    inreplace 'qwtconfig.pri' do |s|
      # change_make_var won't work because there are leading spaces
      s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"
    end

    system "qmake -config release"
    system "make install"
  end
end

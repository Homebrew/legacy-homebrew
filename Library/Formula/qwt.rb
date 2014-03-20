require 'formula'

class Qwt < Formula
  homepage 'http://qwt.sourceforge.net/'
  url 'https://downloads.sourceforge.net/project/qwt/qwt/6.1.0/qwt-6.1.0.tar.bz2'
  sha1 '48a967038f7aa9a9c87c64bcb2eb07c5df375565'

  depends_on 'qt'

  def install
    inreplace 'qwtconfig.pri' do |s|
      # change_make_var won't work because there are leading spaces
      s.gsub! /^\s*QWT_INSTALL_PREFIX\s*=(.*)$/, "QWT_INSTALL_PREFIX=#{prefix}"
    end

    args = ['-config', 'release', '-spec']
    # On Mavericks we want to target libc++, this requires a unsupported/macx-clang-libc++ flag
    if ENV.compiler == :clang and MacOS.version >= :mavericks
      args << "unsupported/macx-clang-libc++"
    else
      args << "macx-g++"
    end
    system 'qmake', *args
    system "make"
    system "make install"
  end

  def caveats; <<-EOS.undent
      The qwtmathml library contains code of the MML Widget from the Qt solutions package.
      Beside the Qwt license you also have to take care of its license.
    EOS
  end
end

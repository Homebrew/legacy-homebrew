require 'formula'

class Wkhtmltopdf < Formula
  homepage 'http://code.google.com/p/wkhtmltopdf/'
  url 'http://wkhtmltopdf.googlecode.com/files/wkhtmltopdf-0.11.0_rc1.tar.bz2'
  sha1 'db03922d281856e503b3d562614e3936285728c7'
  version '0.11.0_rc1'

  depends_on 'qt'

  def install
    # fix that missing TEMP= include.
    inreplace 'common.pri' do |s|
      s.gsub! 'TEMP = $$[QT_INSTALL_LIBS] libQtGui.prl', ''
      s.gsub! 'include($$join(TEMP, "/"))', ''
    end

    # It tries to build universally, but Qt is bottled as 64bit => build error.
    # If we are 64bit, do not compile with -arch i386.  This is a Homebrew
    # issue with our Qt4, not upstream, because wkhtmltopdf bundles a patched
    # Qt4 that Homebrew doesn't use.
    if MacOS.prefer_64_bit?
      inreplace 'src/pdf/pdf.pro', 'x86', 'x86_64'
      inreplace 'src/image/image.pro', 'x86', 'x86_64'
    end

    system 'qmake', '-spec', 'macx-g++'
    system 'make'
    ENV['DYLD_LIBRARY_PATH'] = './bin'
    `bin/wkhtmltopdf --manpage > wkhtmltopdf.1`
    `bin/wkhtmltoimage --manpage > wkhtmltoimage.1`

    # install binaries, libs, and man pages
    bin.install Dir[ "bin/wkh*" ]
    lib.install Dir[ "bin/lib*" ]
    man1.install Dir[ "wkht*.1" ]
  end
end

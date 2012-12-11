require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.5.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.5.tar.gz'
  sha1 'f3095e5c2427b0af1715e2696bdf32bacb50b989'

  option "without-rebuilding-php-parser", "Don't rebuild PHP parser; use provied parser"

  def install
    # Rebuilding the PHP parser, see:
    # http://comments.gmane.org/gmane.comp.gnu.global.bugs/1439
    unless build.include? "without-rebuilding-php-parser"
      system "flex -o libparser/php.c libparser/php.l"
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"

    # we copy these in already
    cd share/'gtags' do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end

  def caveats; <<-EOS.undent
    GNU GLOBAL is distributed with a PHP parser generated with an
    old version of flex(1). That parser has some limitation. See:
      http://comments.gmane.org/gmane.comp.gnu.global.bugs/1439

    Installing GNU GLOBAL with Homebrew will therefor rebuild the
    PHP parser using Mac OS X' newer version of flex(1) which
    generates a parser without the limit.

    You can install GNU GLOBAL without rebuilding the PHP parser
    (and instead use the parser distributed by GNU GLOBAL) by using
    the option '--without-rebuilding-php-parser':

      brew install global --without-rebuilding-php-parser

    Use i.e. if you want to be sure whether a problem is caused by
    the rebuild parser or some other thing in GNU GLOBAL.
    EOS
  end
end

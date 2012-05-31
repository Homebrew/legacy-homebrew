require 'formula'

class Global < Formula
  homepage 'http://www.gnu.org/software/global/'
  url 'http://ftpmirror.gnu.org/global/global-6.2.4.tar.gz'
  mirror 'http://ftp.gnu.org/gnu/global/global-6.2.4.tar.gz'
  md5 'c778d4e52a30706db7a02070cce1078c'

  def options
    [
      ["--without-rebuilding-php-parser", "Don't rebuild PHP parser; use the parser distributed by GNU GLOBAL."],
    ]
  end

  def install
    unless ARGV.include? "--without-rebuilding-php-parser"
      # Rebuilding the PHP parser, see <http://comments.gmane.org/gmane.comp.gnu.global.bugs/1439>.
      system "flex -o libparser/php.c libparser/php.l"
    end
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make install"

    # we copy these in already
    cd share+'gtags' do
      rm %w[README COPYING LICENSE INSTALL ChangeLog AUTHORS]
    end
  end

  def caveats
    s = <<-EOS.undent

      GNU GLOBAL is distributed with a PHP parser generated with an
      old version of flex(1). That parser has some limitation (see
      http://comments.gmane.org/gmane.comp.gnu.global.bugs/1439).

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

    return s
  end
end

require 'formula'

class Libiconv <Formula
  url 'http://ftp.gnu.org/pub/gnu/libiconv/libiconv-1.13.1.tar.gz'
  homepage 'http://www.gnu.org/software/libiconv/'
  md5 '7ab33ebd26687c744a37264a330bbe9a'

  def keg_only?
    :provided_by_osx
  end

  def patches
    { :p1 => [
      'http://svn.macports.org/repository/macports/trunk/dports/textproc/libiconv/files/patch-Makefile.devel',
      'http://svn.macports.org/repository/macports/trunk/dports/textproc/libiconv/files/patch-utf8mac.diff',
      'http://gist.github.com/raw/355571/2fac6d8b7471e4787748f6335ff062908ec0fdc2/gistfile1.txt']
    }
  end

  def install
    ENV.j1
    system "./configure", "--disable-debug", "--disable-dependency-tracking", "--prefix=#{prefix}", "--enable-extra-encodings"
    system "make -f Makefile.devel"
    system "make install"
  end
end

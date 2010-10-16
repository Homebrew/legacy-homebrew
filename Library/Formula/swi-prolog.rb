require 'formula'

class SwiProlog <Formula
  url 'http://www.swi-prolog.org/download/stable/src/pl-5.10.1.tar.gz'
  homepage 'http://www.swi-prolog.org/'
  md5 '9168a2c872d2130467c3e74b80ed3ee0'
  depends_on 'readline'
  depends_on 'gmp'
  depends_on 'jpeg'
  depends_on 'pkg-config'
  depends_on 'fontconfig'
  depends_on 'ncursesw'
  depends_on 'libmcrypt'
  depends_on 'gawk'

  # depends_on 'cmake'

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--with-world", "--x-includes=/usr/X11/include",
                          "--x-libraries=/usr/X11/lib", "--mandir=#{man}"
    system "make"
    system "make check"
    system "make install"
  end
end

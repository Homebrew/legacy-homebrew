require 'formula'

class SwiProlog <Formula
  url 'http://www.swi-prolog.org/download/stable/src/pl-5.10.1.tar.gz'
  homepage 'http://www.swi-prolog.org/'
  md5 '9168a2c872d2130467c3e74b80ed3ee0'

  depends_on "gmp"
  depends_on "readline"

  def install
    # doesn't pick up gmp otherwise
    ENV.append "CFLAGS", ENV['CPPFLAGS']

    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

require 'formula'

class SwiProlog <Formula
  url 'http://www.swi-prolog.org/download/stable/src/pl-5.8.2.tar.gz'
  homepage 'http://www.swi-prolog.org/'
  md5 '478af676cc9801c4181694141c4acbf7'

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

require 'formula'

# See: http://www.cowlark.com/2009-11-15-go/
class Algol68g <Formula
  url 'http://www.xs4all.nl/~jmvdveer/algol68g-1.18.0.bz2'
  homepage 'http://www.xs4all.nl/~jmvdveer/algol.html'
  md5 '949b7eb0c49c327d36f0c7d13e7c8be4'

  def install
    # These folders need to exist for configure to work. Lame.
    bin.mkpath

    system "./configure", "-O3", "--threads", "--bindir=#{bin}", "--cc=#{ENV.cc}"

    # Don't make the docs, they appear to be missing.
    inreplace 'makefile', '@install -m 644 doc/man1/a68g.1 $(man_dir)', ''
    system "make"
    system "make install"
  end
end

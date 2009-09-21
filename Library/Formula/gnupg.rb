require 'brewkit'

class Gnupg <Formula
  @url='ftp://ftp.gnupg.org/gcrypt/gnupg/gnupg-1.4.10.tar.bz2'
  @homepage='http://www.gnupg.org/'
  @sha1='fd1b6a5f3b2dd836b598a1123ac257b8f105615d'

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-asm"

    system "make"
    system "make check"

    # amazingly even the GNU folks can bugger up their Makefiles, so we need
    # to create these directories because the install target has the
    # dependency order wrong
    bin.mkpath
    (libexec+'gnupg').mkpath
    system "make install"
  end
end

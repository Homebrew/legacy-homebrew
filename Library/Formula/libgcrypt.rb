require 'brewkit'

class Libgcrypt <Formula
  @url='ftp://ftp.gnupg.org//gcrypt/libgcrypt/libgcrypt-1.4.4.tar.bz2'
  @homepage='http://www.gnupg.org/'
  @sha1='3987f0efcbb7048c136d5c859e88eee1763a14f6'

  def deps
    'libgpg-error'
  end

  def install
    ENV.j1
    system "./configure", "--prefix=#{prefix}", "--disable-debug", "--disable-dependency-tracking", "--disable-asm"
    system "make install"
  end
end

require 'formula'

class Libassuan <Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libassuan/libassuan-2.0.0.tar.bz2'
  homepage 'http://www.gnupg.org/related_software/libassuan/index.en.html'
  md5 '59bc0ae7194c412d7a522029005684b2'

	depends_on 'libgpg-error'

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make install"
  end
end

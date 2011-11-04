require 'formula'

class Libgcrypt < Formula
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.5.0.tar.bz2'
  sha1 '3e776d44375dc1a710560b98ae8437d5da6e32cf'
  homepage 'http://directory.fsf.org/project/libgcrypt/'

  depends_on 'libgpg-error'

  def patches
    if ENV.compiler == :clang
      { :p0 => "https://trac.macports.org/export/85232/trunk/dports/devel/libgcrypt/files/clang-asm.patch" }
    end
  end

  def install
    ENV.universal_binary	# build fat so wine can use it

    ENV.append 'CFLAGS', "-fheinous-gnu-extensions -std=gnu89" if ENV.compiler == :clang

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{HOMEBREW_PREFIX}"
    # Separate steps, or parallel builds fail
    system "make"
    system "make check"
    system "make install"
  end
end

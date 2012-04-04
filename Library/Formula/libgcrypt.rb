require 'formula'

class Libgcrypt < Formula
  homepage 'http://gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.5.0.tar.bz2'
  sha1 '3e776d44375dc1a710560b98ae8437d5da6e32cf'

  depends_on 'libgpg-error'

  def patches
    if ENV.compiler == :clang
      {:p0 =>
      "https://trac.macports.org/export/85232/trunk/dports/devel/libgcrypt/files/clang-asm.patch"}
    end
  end

  def install
    ENV.universal_binary # build fat so wine can use it

    if ENV.compiler == :clang
      ENV.append 'CFLAGS', '-std=gnu89'
      ENV.append 'CFLAGS', '-fheinous-gnu-extensions'
    end

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{HOMEBREW_PREFIX}"
    # Parallel builds work, but only when run as separate steps
    system "make"
    system "make check"
    system "make install"
  end
end

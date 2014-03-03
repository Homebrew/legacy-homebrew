require 'formula'

class Libgcrypt < Formula
  homepage 'http://gnupg.org/'
  url 'ftp://ftp.gnupg.org/gcrypt/libgcrypt/libgcrypt-1.5.3.tar.bz2'
  sha1 '2c6553cc17f2a1616d512d6870fe95edf6b0e26e'

  bottle do
    cellar :any
    sha1 "a33a63856c29913821deaa1c38d063bb49ce3e8d" => :mavericks
    sha1 "3fb74c54503971bc5d1ab02027d8430dedf06b6f" => :mountain_lion
    sha1 "6b7e4f8ee5c3e71a935bd1785121e84311679543" => :lion
  end

  depends_on 'libgpg-error'

  option :universal

  resource 'config.h.ed' do
    url 'http://trac.macports.org/export/113198/trunk/dports/devel/libgcrypt/files/config.h.ed'
    version '113198'
    sha1 '136f636673b5c9d040f8a55f59b430b0f1c97d7a'
  end if build.universal?

  fails_with :clang do
    build 77
    cause "basic test fails"
  end

  def patches
    if ENV.compiler == :clang and (build.universal? or build.build_32_bit?)
      { :p0 => "https://trac.macports.org/export/85232/trunk/dports/devel/libgcrypt/files/clang-asm.patch" }
    end
  end

  def install
    ENV.universal_binary if build.universal?

    ENV.append 'CFLAGS', '-std=gnu89 -fheinous-gnu-extensions' if ENV.compiler == :clang

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--disable-asm",
                          "--with-gpg-error-prefix=#{HOMEBREW_PREFIX}"

    if build.universal?
      buildpath.install resource('config.h.ed')
      system "ed -s - config.h <config.h.ed"
    end

    # Parallel builds work, but only when run as separate steps
    system "make", "CFLAGS=#{ENV.cflags}"
    system "make check"
    system "make install"
  end
end

class Zzuf < Formula
  desc "Transparent application input fuzzer"
  homepage "http://caca.zoy.org/wiki/zzuf"
  url "http://caca.zoy.org/files/zzuf/zzuf-0.13.tar.gz"
  sha256 "0842c548522028c3e0d9c9cf7d09f6320b661f33824bb6df19ca209851bdf627"

  conflicts_with "libzzip", :because => "both install `zzcat` binaries"

  # Fix OS X-specific bug in zzuf 0.13; see https://trac.macports.org/ticket/29157
  # This has been fixed upstream and should be included in the next release.
  patch :p3 do
    url "https://trac.macports.org/export/78051/trunk/dports/security/zzuf/files/patch-src-libzzuf-lib--mem.c.diff"
    sha256 "51692d0bfaa8dd9bc8e24be7f96212a296f1eb779253325e7aaa0300d625cb2a"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/zzuf", "hd", "-vn", "32", "/dev/zero"
  end
end

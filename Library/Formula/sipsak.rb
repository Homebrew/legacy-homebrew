class Sipsak < Formula
  homepage "http://sourceforge.net/projects/sipsak.berlios/"
  url "https://downloads.sourceforge.net/project/sipsak.berlios/sipsak-0.9.6-1.tar.gz"
  version "0.9.6"
  sha1 "6d2fd2c90ea04be749e48927b3e7fc08c52166b6"

  depends_on "openssl"

  def install
    ENV.append "CFLAGS", "-std=gnu89"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/sipsak", "-V"
  end
end

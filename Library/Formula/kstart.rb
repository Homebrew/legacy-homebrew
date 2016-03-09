class Kstart < Formula
  desc "Modified version of kinit that can use keytabs to authenticate"
  homepage "http://www.eyrie.org/~eagle/software/kstart/"
  url "https://archives.eyrie.org/software/kerberos/kstart-4.2.tar.gz"
  sha256 "2698bc1ab2fb36d49cc946b0cb864c56dd3a2f9ef596bfff59592e13d35315cd"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/k5start", "-h"
  end
end

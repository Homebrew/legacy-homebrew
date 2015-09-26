class Kstart < Formula
  desc "Modified version of kinit that can use keytabs to authenticate"
  homepage "http://www.eyrie.org/~eagle/software/kstart/"
  url "http://archives.eyrie.org/software/kerberos/kstart-4.1.tar.gz"
  sha256 "ad1a71be149d56473319bf3b9bca83a60caa3af463d52c134e8f187103700224"

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

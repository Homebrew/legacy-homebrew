class Vilistextum < Formula
  homepage "http://bhaak.net/vilistextum/"
  url "http://bhaak.net/vilistextum/vilistextum-2.6.9.tar.gz"
  sha1 "d62fe5213b61c0d0356bb2e60757dd535ac0a82b"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}", "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/vilistextum", "-v"
  end
end

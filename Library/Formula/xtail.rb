class Xtail < Formula
  desc "Watch growth of multiple files or directories (like `tail -f`)"
  homepage "http://www.unicom.com/sw/xtail"
  url "http://www.unicom.com/files/xtail-2.1.tar.gz"
  sha256 "75184926dffd89e9405769b24f01c8ed3b25d3c4a8eac60271fc5bb11f6c2d53"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    man1.mkpath
    bin.mkpath
    system "make", "install"
  end

  test do
    system "#{bin}/xtail"
  end
end

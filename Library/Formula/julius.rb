class Julius < Formula
  homepage "http://julius.sourceforge.jp"
  url "http://sourceforge.jp/frs/redir.php?m=iij&f=%2Fjulius%2F60273%2Fjulius-4.3.1.tar.gz"
  sha1 "88f64ae9ed00b6ab5a2d4fe07e3ced141a46c196"

  depends_on "libsndfile"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--mandir=#{man}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/julius.dSYM --help", 1)
  end
end

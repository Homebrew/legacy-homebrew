class Remake < Formula
  homepage "http://bashdb.sourceforge.net/remake/"
  url "https://downloads.sourceforge.net/project/bashdb/remake/4.1%2Bdbg-0.91/remake-4.1%2Bdbg0.91.tar.bz2"
  sha256 "02a1c62b47e99376701f8d99b45fffdf44e8512ecf92794fc6bf5d6779900dfb"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"Makefile").write <<-EOS.undent
      all:
      \techo "Nothing here, move along"
    EOS
    system bin/"remake", "-x"
  end
end

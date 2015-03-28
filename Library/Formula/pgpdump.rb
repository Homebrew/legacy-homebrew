class Pgpdump < Formula
  homepage "http://www.mew.org/~kazu/proj/pgpdump/en/"
  url "http://www.mew.org/~kazu/proj/pgpdump/pgpdump-0.29.tar.gz"
  sha256 "6215d9af806399fec73d81735cf20ce91033a7a89a82c4318c4d1659083ff663"

  def install
    system "./configure", "--prefix=#{prefix}"
    bin.mkpath
    man1.mkpath
    system "make", "install"
  end

  test do
    system "#{bin}/pgpdump", "-v"
  end
end

class Autobench < Formula
  homepage "http://www.xenoclast.org/autobench/"
  url "http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz"
  sha256 "d8b4d30aaaf652df37dff18ee819d8f42751bc40272d288ee2a5d847eaf0423b"

  depends_on "httperf"

  def install
    system "make", "PREFIX=#{prefix}",
                   "MANDIR=#{man1}",
                   "CC=#{ENV.cc}",
                   "CFLAGS=#{ENV.cflags}",
                   "install"
  end

  test do
    system "#{bin}/crfile", "-f", "#{testpath}/test", "-s", "42"
    assert File.exist? "test"
    assert_equal 42, File.size("test")
  end
end

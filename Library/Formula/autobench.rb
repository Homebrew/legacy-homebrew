class Autobench < Formula
  desc "Automatic webserver benchmark tool"
  homepage "http://www.xenoclast.org/autobench/"
  url "http://www.xenoclast.org/autobench/downloads/autobench-2.1.2.tar.gz"
  sha256 "d8b4d30aaaf652df37dff18ee819d8f42751bc40272d288ee2a5d847eaf0423b"

  bottle do
    cellar :any_skip_relocation
    sha256 "37bb6f40825953f9ba176522bc64d74a6375304d7963331aee937417e339964f" => :el_capitan
    sha256 "9884556bd5f7ab7c29a0aa199328cbe609e04437b1ddce4703214ba65f15d40a" => :yosemite
    sha256 "d31d3625f06d036af97b6cc80d62856b9d3eecadb4ed9fe7a0cb9b96f8d9f9a0" => :mavericks
    sha256 "0246ec483143e1f752a6b7a22ddc11a5c213e795bb55c5296646bcedc05d3426" => :mountain_lion
  end

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

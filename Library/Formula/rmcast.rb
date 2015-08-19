class Rmcast < Formula
  desc "IP Multicast library"
  homepage "http://www.land.ufrj.br/tools/rmcast/rmcast.html"
  url "http://www.land.ufrj.br/tools/rmcast/download/rmcast-2.0.0.tar.gz"
  sha256 "79ccbdbe4a299fd122521574eaf9b3e2d524dd5e074d9bc3eb521f1d934a59b1"

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

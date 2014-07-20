require "formula"

class Arping < Formula
  homepage "https://github.com/ThomasHabets/arping"
  url "https://github.com/ThomasHabets/arping/archive/arping-2.13.tar.gz"
  sha1 "a253cdfcb83360d4acd5e4fe1d84ed8105a94829"

  bottle do
    cellar :any
    revision 1
    sha1 "1db7d1377a337897e878c430495d6dc6c7cd8979" => :mavericks
    sha1 "283a532a27da9619d90c2912d794a017d6badf11" => :mountain_lion
    sha1 "6c7f3ef664dc3f119b1d6f0bbabbeeceddcd8941" => :lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libnet"

  def install
    system "./bootstrap.sh"
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make install"
  end
end

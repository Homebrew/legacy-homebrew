class Voms < Formula
  desc "Virtual organization membership service"
  homepage "https://github.com/italiangrid/voms"
  url "https://github.com/italiangrid/voms/archive/2_0_11.tar.gz"
  sha256 "f665712f68fee445bb3247c214a64ecf00a9f858dadd585d26ff076d29e870e0"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}", "--sysconfdir=#{etc}"
    system "make", "install"
  end
end

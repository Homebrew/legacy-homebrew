class Rtl433 < Formula
  desc "Tool to talk to 433Mhz devices using RTL devices"
  homepage "https://github.com/merbanan/rtl_433"
  url "https://github.com/merbanan/rtl_433.git", :revision => "922a76a81820c68e2e5c55a428e5d22135a8be9a"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool"  => :build

  depends_on "librtlsdr"

  def install
    system "autoreconf", "--install"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

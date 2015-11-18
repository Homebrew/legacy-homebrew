class Zproject < Formula
  desc "CLASS Project Generator"
  homepage "https://github.com/zeromq/zproject"
  head "https://github.com/zeromq/zproject.git"

  depends_on "imatix-gsl"
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end

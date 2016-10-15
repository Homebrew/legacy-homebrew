require "formula"

class Makeheaders < Formula
  homepage "http://www.hwaci.com/sw/mkhdr/"
  url "https://github.com/steakknife/makeheaders/archive/1.4-2.tar.gz"
  sha256 "440b506ab27b12fcc238f9bc9cd31029769fe0bd05da34238c017fbb1e18b4fa"
  head "https://github.com/steakknife/makeheaders.git"

  depends_on "automake" => :build
  depends_on "autoconf" => :build

  def install
    system "sh", "./bootstrap"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "makeheaders"
  end
end


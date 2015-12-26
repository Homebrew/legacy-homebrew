class RiemannClient < Formula
  desc "C client library for the Riemann monitoring system"
  homepage "https://github.com/algernon/riemann-c-client"
  url "https://github.com/algernon/riemann-c-client/archive/riemann-c-client-1.3.0.tar.gz"
  sha256 "64bb7ccdb6d7267110932feddcd8c3149588baf3227b05c330bfef97347be995"

  bottle do
    cellar :any
    sha256 "5eac36dbc72334c21da605445504f87bf4c81fae69870df44548749a71d804a8" => :yosemite
    sha256 "7e265d3c44bfde8103f85027fe851e2bdfc30d48074701520143f7b1348eed94" => :mavericks
    sha256 "957c3694c364c71358ac0fdcc3aa39bd7ba5b6afd0d8a8ad7c19cbde45e975be" => :mountain_lion
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "pkg-config" => :build
  depends_on "libtool" => :build

  depends_on "json-c"
  depends_on "protobuf-c"

  def install
    system "autoreconf", "-i"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "check"
    system "make", "install"
  end

  test do
    system "#{bin}/riemann-client", "send", "-h"
  end
end

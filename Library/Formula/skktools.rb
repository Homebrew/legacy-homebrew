class Skktools < Formula
  desc "SKK dictionary maintenance tools"
  homepage "http://openlab.jp/skk/index-j.html"
  url "http://openlab.ring.gr.jp/skk/tools/skktools-1.3.3.tar.gz"
  sha256 "0b4c17b6ca5c5147e08e89e66d506065bda06e7fdbeee038e85d7a7c4d10216d"

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--prefix=#{prefix}",
                          "--with-skkdic-expr2"

    system "make", "CC=#{ENV.cc}"
    ENV.j1
    system "make", "install"
  end
end

require "formula"

class Libschwa < Formula
  homepage "https://github.com/schwa-lab/libschwa"
  url "https://github.com/schwa-lab/libschwa/releases/download/0.2.1/libschwa-0.2.1.tar.gz"
  sha1 "6e81c9996262262c4f2806306812c6bc23dcb54b"

  depends_on "zeromq" => :optional

  def install
    system "./configure", "--prefix=#{prefix}"
    system "make", "install"
    system "make", "check"
  end
end

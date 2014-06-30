require "formula"

class Libbson < Formula
  homepage "https://github.com/mongodb/libbson"
  url "https://github.com/mongodb/libbson/releases/download/0.8.4/libbson-0.8.4.tar.gz"
  sha1 "698d68defaec7ed67d4f17090ae183aaa47a21df"

  def install
    system "./configure", "--enable-silent-rules", "--prefix=#{prefix}"
    system "make", "install"
  end
end

require "formula"

class Valabind < Formula
  homepage "http://radare.org/"
  head "https://github.com/radare/valabind.git"
  url "https://github.com/radare/valabind/archive/0.9.0.tar.gz"
  sha1 "65af558a0116c1d8598992637cfd994cc7e23407"

  depends_on "pkg-config" => :build
  depends_on "swig" => :run
  depends_on "vala"

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end
end

require "formula"

class Libmaa < Formula
  homepage "http://www.dict.org/"
  url "https://downloads.sourceforge.net/project/dict/libmaa/libmaa-1.3.2/libmaa-1.3.2.tar.gz"
  sha1 "4540374c9e66e3f456a8102e0ae75828b7892c6d"

  depends_on "libtool" => :build

  def install
    ENV["LIBTOOL"] = "glibtool"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end
end


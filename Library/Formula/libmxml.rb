require "formula"

class Libmxml < Formula
  homepage "http://www.minixml.org/"
  url "http://www.msweet.org/files/project3/mxml-2.8.tar.gz"
  sha1 "09d88f1720f69b64b76910dfe2a5c5fa24a8b361"

  depends_on :xcode # for docsetutil

  def install
    system "./configure", "--disable-debug",
                          "--enable-shared",
                          "--prefix=#{prefix}"
    system "make"
    system "make install"
  end
end

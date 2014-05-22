require "formula"

class Libopendkim < Formula
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.9.2.tar.gz"
  sha1 "6d6720e60ffe44a689de6732d10e7aba26e24b06"

  depends_on "unbound"

  def install
    # --dsiable-filter: not needed for the library build
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}",
                          "--disable-filter",
                          "--with-unbound=#{Formula['unbound'].opt_prefix}"
    system "make", "install"
  end
end

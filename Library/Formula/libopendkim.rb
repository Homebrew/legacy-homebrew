require "formula"

class Libopendkim < Formula
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.9.2.tar.gz"
  sha1 "6d6720e60ffe44a689de6732d10e7aba26e24b06"
  revision 1

  bottle do
    sha1 "c4ffd7ead8a1f4c5ddf5ed9556e8fc476130b229" => :yosemite
    sha1 "e012df195eee3f3aacd7cb1bb77b23969379b7e0" => :mavericks
    sha1 "bb60d1866f2e9357d9f652cd76311285d595f3f7" => :mountain_lion
  end

  depends_on "unbound"
  depends_on "openssl"

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

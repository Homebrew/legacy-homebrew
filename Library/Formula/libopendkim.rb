require "formula"

class Libopendkim < Formula
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.9.2.tar.gz"
  sha1 "6d6720e60ffe44a689de6732d10e7aba26e24b06"

  bottle do
    sha1 "39e562199abf2f28cffc9d6941627b4c368ecebb" => :mavericks
    sha1 "1d2d00dbc4999405d9fab4a52e9cd7cb5f779db3" => :mountain_lion
    sha1 "4b77b3a6133c8e2dd1df7479890a33b4e8e5c8c8" => :lion
  end

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

require "formula"

class Libopendkim < Formula
  homepage "http://opendkim.org"
  url "https://downloads.sourceforge.net/project/opendkim/opendkim-2.9.2.tar.gz"
  sha1 "6d6720e60ffe44a689de6732d10e7aba26e24b06"

  bottle do
    revision 1
    sha1 "b27c9d6ac17e8b2853112ad8ad51904e1a3c5d9c" => :yosemite
    sha1 "5ab9d02326500931fa34fdba14e8ec4d4b66ba29" => :mavericks
    sha1 "b4e2c0613a097e4e39c0261a29d55746ae14ec16" => :mountain_lion
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

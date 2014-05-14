require "formula"

class Cardpeek < Formula
  homepage "http://pannetrat.com/Cardpeek/"
  url "http://downloads.pannetrat.com/install/cardpeek-0.8.2.tar.gz"
  sha1 "7bd532684891b525ae7b98d2ca91d2bb26cd03bf"

  head "http://cardpeek.googlecode.com/svn/trunk/"

  depends_on "pkg-config" => :build
  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on :x11
  depends_on "gtk+3"
  depends_on "curl"
  depends_on "glib"
  depends_on "lua"

  def install
    # always run autoreconf, neeeded to generate configure for --HEAD,
    # and otherwise needed to reflect changes to configure.ac
    system "autoreconf", "-i"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

require 'formula'

class Cardpeek < Formula
  homepage "http://pannetrat.com/Cardpeek/"
  url "http://downloads.pannetrat.com/get/302b8a00996e9f4180ad/cardpeek-0.8.3.tar.gz"
  mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/Cardpeek/cardpeek-0.8.3.tar.gz"
  sha1 "8cc9c0652f0214ec06badb5b86974c66ca035a43"

  head "http://cardpeek.googlecode.com/svn/trunk/"

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on :autoconf
  depends_on :automake
  depends_on :x11
  depends_on "openssl"
  depends_on "gtk+3"
  depends_on "lua"

  def install
    # always run autoreconf, neeeded to generate configure for --HEAD,
    # and otherwise needed to reflect changes to configure.ac
    system "autoreconf -i"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end

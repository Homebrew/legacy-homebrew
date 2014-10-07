require "formula"

class Cardpeek < Formula
  homepage "http://pannetrat.com/Cardpeek/"

  stable do
    url "http://downloads.pannetrat.com/get/302b8a00996e9f4180ad/cardpeek-0.8.3.tar.gz"
  bottle do
    cellar :any
    sha1 "71775a85560719e72a31284f1852b236daebab7c" => :mavericks
    sha1 "8801e8e235850927169195d1beac9a44566ba33c" => :mountain_lion
    sha1 "d6522d6a501745e2a3ef0744a06e78a6690f81be" => :lion
  end

    mirror "https://raw.githubusercontent.com/DomT4/LibreMirror/master/Cardpeek/cardpeek-0.8.3.tar.gz"
    sha1 "8cc9c0652f0214ec06badb5b86974c66ca035a43"

    # Patch required to fix GTK3.14 fatal build issues. Already merged into HEAD.
    patch :p0 do
      url "https://cardpeek.googlecode.com/issues/attachment?aid=500005000&name=patch-for-gtk-3.14.patch&token=ABZ6GAe27u5TeVC93yVqB58IQsyy6FjQQw%3A1412564556195"
      sha1 "33b27af98546f605e5ab1c4a894c7db8fc2045f8"
    end
  end

  head do
    url "https://cardpeek.googlecode.com/svn/trunk/"
  end

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
    system "autoreconf", "-i"

    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
